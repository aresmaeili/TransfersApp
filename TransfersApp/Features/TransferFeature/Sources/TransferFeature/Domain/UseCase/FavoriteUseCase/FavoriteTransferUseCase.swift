//
//  FavoriteTransferUseCase.swift
//  TransferFeature
//
//  Created by AREM on 11/1/25.
//
import Foundation

import Foundation

protocol FavoriteTransferUseCaseProtocol {
    func fetchFavorites() -> [Transfer]
    func toggleFavoriteStatus(transfer: Transfer)
    func isFavorite(transfer: Transfer) -> Bool
}

final class FavoriteTransferUseCase: FavoriteTransferUseCaseProtocol {

    private let favoritesRepository: FavoriteTransferRepositoryProtocol
    
    init(favoritesRepository: FavoriteTransferRepositoryProtocol) {
        self.favoritesRepository = favoritesRepository
    }
    
    func fetchFavorites() -> [Transfer] {
        favoritesRepository.getFavorites()
    }
    
    func toggleFavoriteStatus(transfer: Transfer) {
        if isFavorite(transfer: transfer) {
            favoritesRepository.remove(transfer: transfer)
        } else {
            favoritesRepository.save(transfer: transfer)

        }
    }

    func isFavorite(transfer: Transfer) -> Bool {
        let favorites = favoritesRepository.getFavorites()
        return favorites.contains(transfer)
    }
}
