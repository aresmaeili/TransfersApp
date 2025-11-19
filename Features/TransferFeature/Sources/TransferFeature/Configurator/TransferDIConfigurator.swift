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

@MainActor
protocol TransferConfiguratorProtocol {
    func makeTransferListModule(coordinator: TransferCoordinator) -> UIViewController
    func makeTransferDetailsModule(transfer: Transfer) -> UIViewController
}

// MARK: - TransferFactory

struct TransferDIConfigurator: TransferConfiguratorProtocol {
    
    // MARK: - Module Builders

    private let favoriteRepository: FavoriteTransferRepositoryProtocol
    private let transferRepository: TransferRepositoryProtocol

     init() {
         let favoriteDataSource = FavoriteDataSource()
         self.favoriteRepository = FavoriteRepositoryImpl(dataSource: favoriteDataSource)
         
         let transferDataSource = TransferAPIDataSource()
         self.transferRepository = TransferRepositoryImpl(dataSource: transferDataSource)
     }
    
    func makeTransferListModule(coordinator: TransferCoordinator) -> UIViewController {

        // Use Case Setup
        let fetchTransfersUseCase: FetchTransfersUseCaseProtocol = FetchTransfersUseCase(repository: transferRepository)
        let favoriteUseCase: FavoriteTransferUseCaseProtocol = FavoriteTransferUseCase(repository: favoriteRepository)
        
        // ViewModel Setup
        let viewModel = TransferListViewModel(fetchTransfersUseCase: fetchTransfersUseCase, favoriteUseCase: favoriteUseCase, coordinator: coordinator)
        
        // ViewController Setup
        let viewController = TransferListViewController.instantiate(from: "TransferList", bundle: .module)
        viewController.viewModel = viewModel
        
        return viewController
    }
    
    func makeTransferDetailsModule(transfer: Transfer) -> UIViewController {
        
        // Use Case Setup
        let favoriteUseCase = FavoriteTransferUseCase(repository: favoriteRepository)
        
        // ViewModel Setup
        let viewModel = TransferDetailsViewModel(
            transfer: transfer,
            favoriteUseCase: favoriteUseCase
        )
        
        // ViewController Setup
        let viewController = TransferDetailsViewController.instantiate(from: "TransferDetails", bundle: .module)
        viewController.viewModel = viewModel
        
        return viewController
    }
}
