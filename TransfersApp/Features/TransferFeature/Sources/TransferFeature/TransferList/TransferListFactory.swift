//
//  TransferListFactory.swift
//  TransferFeature
//
//  Created by AREM on 10/30/25.
//

import UIKit
import RouterCore

struct TransferListFactory: VCFactoryProtocol {
    func makeModule(navigation: UINavigationController) -> UIViewController {
        let storyboard = UIStoryboard(name: "TransferList", bundle: .module)
        guard let vc = storyboard.instantiateViewController(withIdentifier: "TransferListViewController") as? TransferListViewController else {
            assertionFailure("TransferListViewController not found in TransferList.storyboard")
            return UIViewController()
        }
        let api = TransferMockData()
        let repository = TransferRepositoryImpl(api: api)
        let useCase = DefaultFetchTransfersUseCase(repository: repository)
        let favoriteRepository = FavoriteRepositoryImpl()
        let favoriteUseCase = ToggleFavoriteTransferUseCase(favoritesRepository: favoriteRepository)
        let viewModel = TransferListViewModel(transfersUseCase: useCase, toggleFavoriteUseCase: favoriteUseCase, delegate: vc)
        vc.viewModel = viewModel
        return vc
    }
}
