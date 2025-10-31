//
//  FetchTransfersUseCase.swift
//  TransferFeature
//
//  Created by AREM on 10/30/25.
//


import Foundation

protocol FetchTransfersUseCase: Sendable {
    func execute(page: Int) async throws -> [Transfer]
}

final class DefaultFetchTransfersUseCase: FetchTransfersUseCase {
    private let repository: TransferRepository

    init(repository: TransferRepository) {
        self.repository = repository
    }

    func execute(page: Int) async throws -> [Transfer] {
        try await repository.fetchTransfers(page: page)
    }
}
