//
//  TransferListFactory.swift
//  TransferFeature
//
//  Created by AREM on 10/30/25.
//

import UIKit
import RouterCore
import Shared

// MARK: - TransferFactoryProtocol

/// Defines a factory responsible for creating Transfer-related modules.
@MainActor
protocol TransferFactoryProtocol {
    func makeTransferListModule(coordinator: TransferCoordinator) -> UIViewController
    func makeTransferDetailsModule(transfer: Transfer) -> UIViewController
}

// MARK: - TransferFactory

/// Concrete implementation of `TransferFactoryProtocol`.
/// Handles dependency injection and module assembly for the Transfer feature.
struct TransferFactory: TransferFactoryProtocol {
    
    // MARK: - Dependencies
    
    private let transferRepository: TransferRepositoryProtocol
    private let favoriteRepository: FavoriteTransferRepositoryProtocol
    
    // MARK: - Initialization
    
    init(
        transferRepository: TransferRepositoryProtocol,
        favoriteRepository: FavoriteTransferRepositoryProtocol
    ) {
        self.transferRepository = transferRepository
        self.favoriteRepository = favoriteRepository
    }
    
    // MARK: - Module Builders
    
    /// Builds and returns the Transfer List module.
    func makeTransferListModule(coordinator: TransferCoordinator) -> UIViewController {
        // 1. Use Case Setup
        let fetchTransfersUseCase: FetchTransfersUseCaseProtocol =
            FetchTransfersUseCase(repository: transferRepository)
        
        let favoriteUseCase: FavoriteTransferUseCaseProtocol =
            FavoriteTransferUseCase(repository: favoriteRepository)
        
        // 2. ViewModel Setup
        let viewModel = TransferListViewModel(
            fetchTransfersUseCase: fetchTransfersUseCase,
            favoriteUseCase: favoriteUseCase,
            coordinator: coordinator
        )
        
        // 3. ViewController Setup
        let viewController = TransferListViewController.instantiate(
            from: "TransferList",
            bundle: .module
        )
        viewController.viewModel = viewModel
        
        return viewController
    }
    
    /// Builds and returns the Transfer Details module.
    func makeTransferDetailsModule(transfer: Transfer) -> UIViewController {
        //  Use Case Setup
        let favoriteUseCase = FavoriteTransferUseCase(repository: favoriteRepository)
        
        //  ViewModel Setup
        let viewModel = TransferDetailsViewModel(
            transfer: transfer,
            favoriteUseCase: favoriteUseCase
        )
        
        //  ViewController Setup
        let viewController = TransferDetailsViewController.instantiate(
            from: "TransferDetails",
            bundle: .module
        )
        viewController.viewModel = viewModel
        
        return viewController
    }
}
