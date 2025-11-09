//
//  TransferRepository.swift
//  TransferFeature
//
//  Created by AREM on 10/30/25.
//

import Foundation

final class TransferRepositoryImpl: TransferRepositoryProtocol {
    
    private let dataSource: TransferDataSourceProtocol

    init(dataSource: TransferDataSourceProtocol) {
        self.dataSource = dataSource
    }

    func fetchTransfers(page: Int) async throws -> [Transfer] {

        let dtos: [Transfer] = try await dataSource.fetchTransfers(page: page)
        return dtos.map { $0 }
    }
}

