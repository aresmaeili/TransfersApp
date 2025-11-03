//
//  DefaultFetchTransfersUseCase.swift
//  TransferFeature
//
//  Created by AREM on 11/1/25.
//

import Foundation

// MARK: - FetchTransfersUseCaseProtocol

protocol FetchTransfersUseCaseProtocol: Sendable {
    func fetchTransfers(page: Int) async throws -> [Transfer]
    func sortTransfers(_ transfers: [Transfer], by option: SortOption) -> [Transfer]
}

// MARK: - FetchTransfersUseCase

final class FetchTransfersUseCase: FetchTransfersUseCaseProtocol {
    
    // MARK: - Dependencies
    
    private let repository: TransferRepositoryProtocol
    
    // MARK: - Initialization
    
    init(repository: TransferRepositoryProtocol) {
        self.repository = repository
    }
    
    // MARK: - FetchTransfersUseCaseProtocol
    
    func fetchTransfers(page: Int) async throws -> [Transfer] {
        try await repository.fetchTransfers(page: page)
    }
    
    func sortTransfers(_ transfers: [Transfer], by option: SortOption) -> [Transfer] {
        switch option {
        case .nameAscending:
            return transfers.sorted { $0.name.localizedCaseInsensitiveCompare($1.name) == .orderedAscending }
        case .nameDescending:
            return transfers.sorted { $0.name.localizedCaseInsensitiveCompare($1.name) == .orderedDescending }
        case .dateAscending:
            return transfers.sorted { $0.date < $1.date }
        case .dateDescending:
            return transfers.sorted { $0.date > $1.date }
        case .amountAscending:
            return transfers.sorted { $0.amount < $1.amount }
        case .amountDescending:
            return transfers.sorted { $0.amount > $1.amount }
        case .none:
            return transfers
        }
    }
}
