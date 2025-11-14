//
//  FavoriteTransferUseCase.swift
//  TransferFeature
//
//  Created by AREM on 11/1/25.
//

import Foundation

// MARK: - FavoriteTransferUseCaseProtocol

protocol FavoriteTransferUseCaseProtocol: Sendable {
    func fetchFavorites() async -> [Transfer]
    func favorite(at index: Int) async -> Transfer?
    func favoritesCount() async -> Int
    func isFavorite(_ transfer: Transfer) async -> Bool
    func toggleFavorite(_ transfer: Transfer) async
}

// MARK: - FavoriteTransferUseCase

final class FavoriteTransferUseCase: FavoriteTransferUseCaseProtocol {
    
    // MARK: - Dependencies
    
    private let repository: FavoriteTransferRepositoryProtocol
    
    // MARK: - Initialization
    
    init(repository: FavoriteTransferRepositoryProtocol) {
        self.repository = repository
    }
    
    // MARK: - FavoriteTransferUseCaseProtocol Implementation
    
    func fetchFavorites() async -> [Transfer] {
        await repository.getFavorites()
    }
    
    func favorite(at index: Int) async -> Transfer? {
        let items = await repository.getFavorites()
        return items[safe: index]
    }
    
    func favoritesCount() async -> Int {
        let items = await repository.getFavorites()
        return items.count
    }
    
    func isFavorite(_ transfer: Transfer) async -> Bool {
        await repository.contains(transfer)
    }
    
    func toggleFavorite(_ transfer: Transfer) async {
        if await repository.contains(transfer) {
            await repository.remove(transfer)
        } else {
            await repository.save(transfer)
        }
    }
}
