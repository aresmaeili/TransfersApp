//
//  TransferRepository.swift
//  TransferFeature
//
//  Created by AREM on 10/30/25.
//

import Foundation

final actor TransferRepositoryImpl: TransferRepositoryProtocol {
    
    private let dataSource: TransferDataSourceProtocol

    init(dataSource: TransferDataSourceProtocol) {
        self.dataSource = dataSource
    }

    func fetchTransfers(page: Int) async throws -> [Transfer] {
        let dtos: [Transfer] = try await dataSource.fetchTransfers(page: page)
        return dtos.map { $0 }
//        NOTE: Must convert to Domain Data to loose coupling
    }
    
//        NOTE: Must have ultra logics on data and make new values to next levels

}

