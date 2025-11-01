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
    func makeTransferDetailsModule(transfer: Transfer,coordinator: TransferCoordinator) -> UIViewController
}

struct TransferFactory: TransferFactoryProtocol {
    
    func makeTransferListModule(coordinator: TransferCoordinator) -> UIViewController {
        let vc = TransferListViewController.instantiate(from: "TransferList", bundle: .module)
        let api = TransferAPI()
        let repository = TransferRepositoryImpl(api: api)
        let useCase = DefaultFetchTransfersUseCase(repository: repository)
        let favoriteRepository = FavoriteRepositoryImpl()
        let favoriteUseCase = FavoriteTransferUseCase(favoritesRepository: favoriteRepository)
        let viewModel = TransferListViewModel(transfersUseCase: useCase, favoriteUseCase: favoriteUseCase, delegate: vc)
        vc.viewModel = viewModel
        vc.router = coordinator
        return vc
    }
    
    func makeTransferDetailsModule(transfer: Transfer, coordinator: TransferCoordinator) -> UIViewController {
        let vc = TransferDetailsViewController.instantiate(from: "TransferDetails", bundle: .module)
//        let viewModel = TransferDetailsViewModel(transfer: transfer)
//        vc.viewModel = viewModel
        return vc
    }
}

