//
//  FavoriteTransferRepositoryProtocol.swift
//  TransferFeature
//
//  Created by AREM on 10/31/25.
//

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
        var updatedFavorites = storedFavorites
        updatedFavorites.removeAll { $0.id == transfer.id }
        storedFavorites = updatedFavorites
    }
    
    func isFavorite(transfer: Transfer) -> Bool {
            return storedFavorites.contains(where: { $0.id == transfer.id })
        }
}
