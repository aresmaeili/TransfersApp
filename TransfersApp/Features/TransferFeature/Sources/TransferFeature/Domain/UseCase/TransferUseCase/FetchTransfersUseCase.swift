//
//  DefaultFetchTransfersUseCase.swift
//  TransferFeature
//
//  Created by AREM on 11/1/25.
//
import Foundation

protocol FetchTransfersUseCaseProtocol: Sendable {
    func fetchTransfers(page: Int) async throws -> [Transfer]
}

final class FetchTransfersUseCase: FetchTransfersUseCaseProtocol {
    private let repository: TransferRepositoryProtocol

    init(repository: TransferRepositoryProtocol) {
        self.repository = repository
    }

    func fetchTransfers(page: Int) async throws -> [Transfer] {
        try await repository.fetchTransfers(page: page)
    }
}
