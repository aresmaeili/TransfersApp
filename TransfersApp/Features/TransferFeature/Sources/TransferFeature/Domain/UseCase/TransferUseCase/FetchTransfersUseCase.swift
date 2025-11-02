//
//  DefaultFetchTransfersUseCase.swift
//  TransferFeature
//
//  Created by AREM on 11/1/25.
//

import Foundation

// MARK: - FetchTransfersUseCaseProtocol

/// Defines the use case for retrieving transfers, either from a remote API or local source.
protocol FetchTransfersUseCaseProtocol: Sendable {
    func fetchTransfers(page: Int) async throws -> [Transfer]
}

// MARK: - FetchTransfersUseCase

/// The default implementation of `FetchTransfersUseCaseProtocol`.
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
}
