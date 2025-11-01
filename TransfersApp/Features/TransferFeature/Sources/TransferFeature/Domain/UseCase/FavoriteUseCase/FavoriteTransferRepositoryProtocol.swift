//
//  FavoriteTransferRepositoryProtocol.swift
//  TransferFeature
//
//  Created by AREM on 11/1/25.
//

import Foundation

protocol FavoriteTransferRepository {
    /// Retrieves all currently favorited transfers.
    func getFavorites() -> [Transfer]
    /// Saves a transfer to the favorites store.
    func save(transfer: Transfer)
    /// Removes a transfer from the favorites store.
    func remove(transfer: Transfer)
}
