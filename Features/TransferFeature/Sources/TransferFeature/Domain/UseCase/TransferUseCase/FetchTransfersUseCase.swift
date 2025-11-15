//
//  DefaultFetchTransfersUseCase.swift
//  TransferFeature
//
//  Created by AREM on 11/1/25.
//

import Foundation

protocol FetchTransfersUseCaseProtocol: Sendable {
    mutating func fetchTransfers() async throws -> [Transfer]
    mutating func refreshTransfers()
    var listEnded: Bool { get }
}

// MARK: - FetchTransfersUseCase

struct FetchTransfersUseCase: FetchTransfersUseCaseProtocol {
      
    // MARK: - Dependencies
    
    private let repository: TransferRepositoryProtocol
    private(set) var listEnded: Bool = false
    private var currentPage: Int = 1
    
    // MARK: - Initialization
    
    init(repository: TransferRepositoryProtocol) {
        self.repository = repository
    }

    // MARK: - FetchTransfersUseCaseProtocol
    
    mutating func fetchTransfers() async throws -> [Transfer] {
        if listEnded {
            return []
        }
        let transfers = try await repository.fetchTransfers(page: currentPage)
        if transfers.isEmpty {
            listEnded = true
        } else {
            currentPage += 1
        }
        return transfers
    }
    
    mutating func refreshTransfers() {
        currentPage = 1
        listEnded = false
    }
    
//    NOTE: can do validation - empty response logic - caching - Retry rules - Filtering - Sorting - Deduplication
}
