//
//  TransfersCoordinator.swift
//  TransferFeature
//
//  Created by AREM on 10/30/25.
//

import RouterCore
import UIKit

public final class TransferCoordinator: BaseCoordinator {
    
    public override func start() {
        showTransfersList()
    }

    private func showTransfersList() {
        let factory = TransferListFactory()
        let vc = factory.makeModule(navigation: navigationController)
        navigationController.pushViewController(vc, animated: true)
    }
}

