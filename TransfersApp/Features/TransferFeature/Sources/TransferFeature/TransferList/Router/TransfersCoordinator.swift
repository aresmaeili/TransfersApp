//
//  TransfersCoordinator.swift
//  TransferFeature
//
//  Created by AREM on 10/30/25.
//

import RouterCore
import UIKit

public final class TransfersCoordinator: BaseCoordinator {
    
    public override func start() {
        showTransfersList()
    }
    
    private func showTransfersList() {
        let storyboard = UIStoryboard(name: "TransferList", bundle: .module)
        let vc = storyboard.instantiateViewController(withIdentifier: "TransferListViewController") as! TransferListViewController
        navigationController.pushViewController(vc, animated: true)
    }
    
    func showTransferDetail(transfer: Transfer) {
        // TODO: navigate to detail page
    }
}
