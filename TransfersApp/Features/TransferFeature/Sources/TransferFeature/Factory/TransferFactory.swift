//
//  TransferListFactory.swift
//  TransferFeature
//
//  Created by AREM on 10/30/25.
//

import UIKit
import RouterCore
import Shared

@MainActor
protocol TransferFactoryProtocol {
    func makeTransferListModule(router: TransferCoordinator) -> UIViewController
    func makeTransferDetailsModule(transfer: Transfer) -> UIViewController
}

struct TransferFactory: TransferFactoryProtocol {
    

        private let transferRepository: TransferRepositoryProtocol
        private let favoriteRepository: FavoriteTransferRepositoryProtocol
        
        init(transferRepository: TransferRepositoryProtocol, favoriteRepository: FavoriteTransferRepositoryProtocol) {
            self.transferRepository = transferRepository
            self.favoriteRepository = favoriteRepository
        }
    
    func makeTransferListModule(router: TransferCoordinator) -> UIViewController {
        
        // 1. Use Cases Setup
        let fetchTransfersUseCase: FetchTransfersUseCaseProtocol = FetchTransfersUseCase(repository: transferRepository)
        let favoriteTransferUseCase: FavoriteTransferUseCaseProtocol = FavoriteTransferUseCase(favoritesRepository: favoriteRepository)
        
        
        // 2. ViewModel Setup
        let viewModel = TransferListViewModel(fetchTransfersUseCase: fetchTransfersUseCase, favoriteUseCase: favoriteTransferUseCase, router: router)
        
        // 3. ViewController Setup
        let viewController = TransferListViewController.instantiate(from: "TransferList", bundle: .module)
        viewController.viewModel = viewModel
        return viewController
    }
    
    func makeTransferDetailsModule(transfer: Transfer) -> UIViewController {
        // 1. Use Cases Setup
        let favoriteUseCase = FavoriteTransferUseCase(favoritesRepository: favoriteRepository)
        
        // 2. ViewModel Setup
        let viewModel = TransferDetailsViewModel(transfer: transfer, favoriteUseCase: favoriteUseCase)
        
        // 3. ViewController Setup
        let viewController = TransferDetailsViewController.instantiate(from: "TransferDetails", bundle: .module)
        viewController.viewModel = viewModel
        return viewController
    }
}

