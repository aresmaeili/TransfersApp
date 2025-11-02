//
//  TransferRepository.swift
//  TransferFeature
//
//  Created by AREM on 10/30/25.
//

import Foundation

final class TransferRepositoryImpl: TransferRepositoryProtocol {
    
    private let dataSource: TransferDataSource

    init(dataSource: TransferDataSource) {
        self.dataSource = dataSource
    }

    func fetchTransfers(page: Int) async throws -> [Transfer] {
        
//       TODO: thiss
//        let dtos: [TransferDTO] = try await dataSource.fetchTransfers(page: page)
//        return dtos.map { dto in
//                    // فرض بر وجود متد/Initializer برای نگاشت
//                    return Transfer(dto: dto)
//                }
//        return dtos.map { $0 }
//        
        
        let dtos: [Transfer] = try await dataSource.fetchTransfers(page: page)
        return dtos.map { $0 }
    }
}
