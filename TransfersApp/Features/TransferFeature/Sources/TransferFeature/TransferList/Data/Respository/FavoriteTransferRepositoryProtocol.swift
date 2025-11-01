//
//  FavoriteTransferRepositoryProtocol.swift
//  TransferFeature
//
//  Created by AREM on 10/31/25.
//


import Foundation

protocol FavoriteTransferRepositoryProtocol {
    /// Retrieves all currently favorited transfers.
    func getFavorites() -> [Transfer]
    /// Saves a transfer to the favorites store.
    func save(transfer: Transfer)
    /// Removes a transfer from the favorites store.
    func remove(transfer: Transfer)
}

import Foundation

final class FavoriteRepositoryImpl: FavoriteTransferRepositoryProtocol {

    @UserDefaultTransfers private var storedFavorites: [Transfer]

    // MARK: - FavoriteTransferRepositoryProtocol Implementation
    func getFavorites() -> [Transfer] {
        return storedFavorites
    }
    
    func save(transfer: Transfer) {
        if !storedFavorites.contains(where: { $0.id == transfer.id }) {
            
            var updatedFavorites = storedFavorites
            updatedFavorites.append(transfer)
            storedFavorites = updatedFavorites
        }
    }
    
    func remove(transfer: Transfer) {
        // Read, modify, and assign the new array.
        var updatedFavorites = storedFavorites
        updatedFavorites.removeAll { $0.id == transfer.id }
        
        // Assigning triggers the property wrapper's setter for saving.
        storedFavorites = updatedFavorites
    }
    
}
