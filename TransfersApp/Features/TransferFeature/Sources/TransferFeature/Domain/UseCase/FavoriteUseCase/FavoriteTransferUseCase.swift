//
//  FavoriteTransferUseCase.swift
//  TransferFeature
//
//  Created by AREM on 11/1/25.
//
import Foundation

final class FavoriteTransferUseCase: FavoriteTransferUseCaseProtocol {

    private let favoritesRepository: FavoriteTransferRepository
    
    init(favoritesRepository: FavoriteTransferRepository) {
        self.favoritesRepository = favoritesRepository
    }
    
    func execute(transfer: Transfer) {
        if checkIsFavorite(transfer: transfer) {
            favoritesRepository.remove(transfer: transfer)
        } else {
            favoritesRepository.save(transfer: transfer)

        }
    }
    
    func getFavorites() -> [Transfer] {
        favoritesRepository.getFavorites()
    }
    
    func checkIsFavorite(transfer: Transfer) -> Bool {
        let favorites = favoritesRepository.getFavorites()
        return favorites.contains(transfer)
    }
}
