//
//  TransferListFactory.swift
//  TransferFeature
//
//  Created by AREM on 10/30/25.
//

import UIKit
import RouterCore

@MainActor
struct TransferListFactory: VCFactoryProtocol {
    func makeModule(navigation: UINavigationController) -> UIViewController {
        let storyboard = UIStoryboard(name: "TransferList", bundle: .module)
        guard let vc = storyboard.instantiateViewController(withIdentifier: "TransferListViewController") as? TransferListViewController else {
            assertionFailure("TransferListViewController not found in TransferList.storyboard")
            return UIViewController()
        }
        let api = TransferAPI()
        let repository = TransferRepositoryImpl(api: api)
        let useCase = DefaultFetchTransfersUseCase(repository: repository)
        let viewModel = TransferListViewModel(transfersUseCase: useCase, delegate: vc)
        vc.viewModel = viewModel
        return vc
    }
}
