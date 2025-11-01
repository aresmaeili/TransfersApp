//
//  TransfersCoordinator.swift
//  TransferFeature
//
//  Created by AREM on 10/30/25.
//
import RouterCore
import UIKit
import Foundation

public final class TransferCoordinator: BaseCoordinator {
    
    public override init(navigationController: UINavigationController) {
        super.init(navigationController: navigationController)
    }
    
    let factory = TransferFactory(service: TransferAPI())

    public override func start() {
        showTransfersList()
    }

    private func showTransfersList() {
        let vc = factory.makeTransferListModule(coordinator: self)
        navigationController.pushViewController(vc, animated: true)
    }
    
    func showTransfersDetails(transfer: Transfer) {
        let vc = factory.makeTransferDetailsModule(transfer: transfer, coordinator: self)
        navigationController.pushViewController(vc, animated: true)
    }
}
