//
//  FavoriteTransferRepositoryProtocol.swift
//  TransferFeature
//
//  Created by AREM on 11/1/25.
//

import Foundation

public protocol FavoriteTransferRepositoryProtocol {
    func getFavorites() -> [Transfer]
    func save(transfer: Transfer)
    func remove(transfer: Transfer)
    func isFavorite(transfer: Transfer) -> Bool
}
