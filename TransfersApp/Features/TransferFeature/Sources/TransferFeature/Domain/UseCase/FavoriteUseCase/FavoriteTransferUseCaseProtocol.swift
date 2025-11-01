//
//  ToggleFavoriteTransferUseCaseProtocol.swift
//  TransferFeature
//
//  Created by AREM on 10/31/25.
//


import Foundation

/// Defines the interface for adding or removing a transfer from favorites.
protocol FavoriteTransferUseCaseProtocol {
    func getFavorites() -> [Transfer]
    func execute(transfer: Transfer)
}
