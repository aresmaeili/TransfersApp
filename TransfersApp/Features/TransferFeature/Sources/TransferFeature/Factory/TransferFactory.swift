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
    func makeTransferListModule(coordinator: TransferCoordinator) -> UIViewController
    func makeTransferDetailsModule(transfer: Transfer) -> UIViewController
}

struct TransferFactory: TransferFactoryProtocol {
    
    let service: TransferDataSource

    func makeTransferListModule(coordinator: TransferCoordinator) -> UIViewController {
        let vc = TransferListViewController.instantiate(from: "TransferList", bundle: .module)
        let repository = TransferRepositoryImpl(service: service)
        let useCase = DefaultFetchTransfersUseCase(repository: repository)
        let favoriteRepository = FavoriteRepositoryImpl()
        let favoriteUseCase = FavoriteTransferUseCase(favoritesRepository: favoriteRepository)
        let viewModel = TransferListViewModel(transfersUseCase: useCase, favoriteUseCase: favoriteUseCase, router: coordinator)
        vc.viewModel = viewModel
        return vc
    }
    
    func makeTransferDetailsModule(transfer: Transfer) -> UIViewController {
        let vc = TransferDetailsViewController.instantiate(from: "TransferDetails", bundle: .module)
        let favoriteRepository = FavoriteRepositoryImpl()
        let favoriteUseCase = FavoriteTransferUseCase(favoritesRepository: favoriteRepository)
        let viewModel = TransferDetailsViewModel(transfer: transfer, favoriteUseCase: favoriteUseCase)
        vc.viewModel = viewModel
        return vc
    }
}

