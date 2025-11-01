//
//  TransferRepository.swift
//  TransferFeature
//
//  Created by AREM on 10/30/25.
//

import Foundation

final class TransferRepositoryImpl: TransferRepository {
    
    private let service: TransferDataSource

    init(service: TransferDataSource) {
        self.service = service
    }

    func fetchTransfers(page: Int) async throws -> [Transfer] {
        let dtos = try await service.fetchTransfers(page: page)
        return dtos.map { $0 }
    }
}
