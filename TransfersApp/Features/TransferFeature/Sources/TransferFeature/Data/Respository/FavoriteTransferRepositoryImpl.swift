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
    
    // MARK: - Storage
    
    @UserDefaultTransfers private var storedFavorites: [Transfer]
    
    // MARK: - Initialization
    
    init() {
        // Ensures default empty state
        if storedFavorites.isEmpty {
            storedFavorites = []
        }
    }
    
    // MARK: - FavoriteTransferRepositoryProtocol
    
    func getFavorites() -> [Transfer] {
        storedFavorites
    }
    
    func save(transfer: Transfer) {
        guard !storedFavorites.contains(where: { $0.id == transfer.id }) else { return }
        
        var updated = storedFavorites
        updated.append(transfer)
        storedFavorites = updated
    }
    
    func remove(transfer: Transfer) {
        var updated = storedFavorites
        updated.removeAll { $0.id == transfer.id }
        storedFavorites = updated
    }
    
    func isFavorite(transfer: Transfer) -> Bool {
        storedFavorites.contains { $0.id == transfer.id }
    }
}
