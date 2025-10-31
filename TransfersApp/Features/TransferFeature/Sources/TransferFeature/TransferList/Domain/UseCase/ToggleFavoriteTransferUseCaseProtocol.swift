//
//  ToggleFavoriteTransferUseCaseProtocol.swift
//  TransferFeature
//
//  Created by AREM on 10/31/25.
//


import Foundation

/// Defines the interface for adding or removing a transfer from favorites.
protocol ToggleFavoriteTransferUseCaseProtocol {
    func getFavorites() -> [Transfer]
    func execute(transfer: Transfer, shouldBeFavorite: Bool)
}

final class ToggleFavoriteTransferUseCase: ToggleFavoriteTransferUseCaseProtocol {

    private let favoritesRepository: FavoriteTransferRepositoryProtocol
    
    init(favoritesRepository: FavoriteTransferRepositoryProtocol) {
        self.favoritesRepository = favoritesRepository
    }
    
    func execute(transfer: Transfer, shouldBeFavorite: Bool) {
        if shouldBeFavorite {
            favoritesRepository.save(transfer: transfer)
        } else {
            favoritesRepository.remove(transfer: transfer)
        }
    }
    
    func getFavorites() -> [Transfer] {
        favoritesRepository.getFavorites()
    }
}
