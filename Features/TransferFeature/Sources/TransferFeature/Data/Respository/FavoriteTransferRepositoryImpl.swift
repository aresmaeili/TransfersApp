//
//  FavoriteTransferRepositoryProtocol.swift
//  TransferFeature
//
//  Created by AREM on 10/31/25.
//

import Foundation

// MARK: - FavoriteRepositoryImpl

/// Repository responsible for persisting and managing favorite transfers.
final class FavoriteRepositoryImpl: FavoriteTransferRepositoryProtocol {
    
    private let dataSource: FavoriteDataSourceProtocol

    init(dataSource: FavoriteDataSourceProtocol) {
        self.dataSource = dataSource
    }
    
    // MARK: - FavoriteTransferRepositoryProtocol
    
    func getFavorites() -> [Transfer] {
        dataSource.getFavorites()
    }
    
    func save(transfer: Transfer) {
        dataSource.save(transfer: transfer)
    }
    
    func remove(transfer: Transfer) {
        dataSource.remove(transfer: transfer)
    }
    
    func isFavorite(transfer: Transfer) -> Bool {
        dataSource.isFavorite(transfer: transfer)
    }
}
