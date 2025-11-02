//
//  FavoriteTransferUseCase.swift
//  TransferFeature
//
//  Created by AREM on 11/1/25.
//

import Foundation

// MARK: - FavoriteTransferUseCaseProtocol

/// Defines the operations available for managing favorite transfers.
protocol FavoriteTransferUseCaseProtocol {
    func fetchFavorites() -> [Transfer]
    func toggleFavoriteStatus(transfer: Transfer)
    func isFavorite(transfer: Transfer) -> Bool
}

// MARK: - FavoriteTransferUseCase

/// Handles business logic related to marking and retrieving favorite transfers.
final class FavoriteTransferUseCase: FavoriteTransferUseCaseProtocol {
    
    // MARK: - Dependencies
    
    private let repository: FavoriteTransferRepositoryProtocol
    
    // MARK: - Initialization
    
    init(repository: FavoriteTransferRepositoryProtocol) {
        self.repository = repository
    }
    
    // MARK: - FavoriteTransferUseCaseProtocol Implementation
    
    func fetchFavorites() -> [Transfer] {
        repository.getFavorites()
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
