//
//  DefaultFetchTransfersUseCase.swift
//  TransferFeature
//
//  Created by AREM on 11/1/25.
//
import Foundation

final class DefaultFetchTransfersUseCase: FetchTransfersUseCase {
    private let repository: TransferRepository

    init(repository: TransferRepository) {
        self.repository = repository
    }

    func execute(page: Int) async throws -> [Transfer] {
        try await repository.fetchTransfers(page: page)
    }
}
