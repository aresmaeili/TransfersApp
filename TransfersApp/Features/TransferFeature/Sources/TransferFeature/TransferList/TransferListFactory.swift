//
//  TransferListFactory.swift
//  TransferFeature
//
//  Created by AREM on 10/30/25.
//

import UIKit
import RouterCore
import Shared

struct TransferListFactory: VCFactoryProtocol {
    func makeModule(navigation: UINavigationController) -> UIViewController {
        let vc = TransferListViewController.instantiate(from: "TransferList", bundle: .module)
        let api = TransferMockData()
        let repository = TransferRepositoryImpl(api: api)
        let useCase = DefaultFetchTransfersUseCase(repository: repository)
        let favoriteRepository = FavoriteRepositoryImpl()
        let favoriteUseCase = FavoriteTransferUseCase(favoritesRepository: favoriteRepository)
        let viewModel = TransferListViewModel(transfersUseCase: useCase, favoriteUseCase: favoriteUseCase, delegate: vc)
        vc.viewModel = viewModel
        return vc
    }
}
