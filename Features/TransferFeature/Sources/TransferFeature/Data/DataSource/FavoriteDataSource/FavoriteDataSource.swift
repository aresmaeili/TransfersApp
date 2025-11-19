//
//  FavoriteDataSource.swift
//  TransferFeature
//
//  Created by AREM on 11/5/25.
//

import Foundation

protocol FavoriteDataSourceProtocol: Sendable {
    func getFavorites() async -> [Transfer]
    func save(transfer: Transfer) async
    func remove(transfer: Transfer) async
    func isFavorite(transfer: Transfer) async -> Bool
}

// MARK: - FavoriteDataSource (Actor)

actor FavoriteDataSource: FavoriteDataSourceProtocol {
    
    // MARK: - Storage
    
    @UserDefaultTransfers private var storedFavorites: [Transfer]

    // MARK: - FavoriteTransferRepositoryProtocol
    
    func getFavorites() async -> [Transfer] {
        return storedFavorites
    }
    
    func save(transfer: Transfer) async {
        guard !storedFavorites.contains(where: { $0.id == transfer.id }) else { return }
        
        var updated = storedFavorites
        updated.append(transfer)
        storedFavorites = updated
    }
    
    func remove(transfer: Transfer) async {
        var updated = storedFavorites
        updated.removeAll { $0.id == transfer.id }
        storedFavorites = updated
    }
    
    func isFavorite(transfer: Transfer) async -> Bool {
        storedFavorites.contains { $0.id == transfer.id }
    }
}
