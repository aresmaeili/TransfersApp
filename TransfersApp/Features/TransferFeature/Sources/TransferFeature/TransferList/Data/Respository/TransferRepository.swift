//
//  TransferRepository.swift
//  TransferFeature
//
//  Created by AREM on 10/30/25.
//

import Foundation

protocol TransferRepository: Sendable {
    func fetchTransfers() async throws -> [Transfer]
}

final class TransferRepositoryImpl: TransferRepository {
    
    private let api: TransferDataSource

    init(api: TransferDataSource) {
        self.api = api
    }

    func fetchTransfers() async throws -> [Transfer] {
        let dtos = try await api.fetchTransfers()
        return dtos.map { $0 }
    }
}
