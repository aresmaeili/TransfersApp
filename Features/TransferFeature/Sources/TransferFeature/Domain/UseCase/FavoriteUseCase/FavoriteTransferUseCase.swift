//
//  FavoriteTransferUseCase.swift
//  TransferFeature
//
//  Created by AREM on 11/1/25.
//

import Foundation

// MARK: - FavoriteTransferUseCaseProtocol

protocol FavoriteTransferUseCaseProtocol {
    var isFavoriteExist: Bool { get }
    func getFavoriteItem(at index: Int) -> Transfer?
    var favoritesCount: Int { get }
    func fetchFavorites() -> [Transfer]
    func toggleFavoriteStatus(transfer: Transfer)
    func isFavorite(transfer: Transfer) -> Bool
}

// MARK: - FavoriteTransferUseCase

final class FavoriteTransferUseCase: FavoriteTransferUseCaseProtocol {
    
    // MARK: - Dependencies
    
    private let repository: FavoriteTransferRepositoryProtocol
    
    // MARK: - Initialization
    
    init(repository: FavoriteTransferRepositoryProtocol) {
        self.repository = repository
    }
    
    
    private var allFavorites: [Transfer] { fetchFavorites() }

    var favoritesCount: Int { allFavorites.count }
    
    
    var isFavoriteExist: Bool {
        !allFavorites.isEmpty
    }
    
    // MARK: - FavoriteTransferUseCaseProtocol Implementation
    
    func fetchFavorites() -> [Transfer] {
        repository.getFavorites()
    }
    
    func getFavoriteItem(at index: Int) -> Transfer? {
        allFavorites[safe: index]
    }
    
    func toggleFavoriteStatus(transfer: Transfer) {
        if isFavorite(transfer: transfer) {
            repository.remove(transfer: transfer)
        } else {
            repository.save(transfer: transfer)
        }
    }
    
    func isFavorite(transfer: Transfer) -> Bool {
        repository.isFavorite(transfer: transfer)
    }
}
