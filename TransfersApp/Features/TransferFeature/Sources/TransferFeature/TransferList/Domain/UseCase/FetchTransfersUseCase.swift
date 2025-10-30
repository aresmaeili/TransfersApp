//
//  FetchTransfersUseCase.swift
//  TransferFeature
//
//  Created by AREM on 10/30/25.
//


import Foundation

protocol FetchTransfersUseCase: Sendable {
    func execute() async throws -> [Transfer]
}

final class DefaultFetchTransfersUseCase: FetchTransfersUseCase {
    private let repository: TransferRepository

    init(repository: TransferRepository) {
        self.repository = repository
    }

    func execute() async throws -> [Transfer] {
        try await repository.fetchTransfers()
    }
}
