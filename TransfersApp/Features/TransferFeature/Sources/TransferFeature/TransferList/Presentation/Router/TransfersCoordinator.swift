//
//  TransfersCoordinator.swift
//  TransferFeature
//
//  Created by AREM on 10/30/25.
//

import RouterCore
import UIKit

public final class TransferCoordinator: BaseCoordinator {
    
    var isTestAndOpenDetails: Bool {
        return true
    }
    
    let factory = TransferFactory()

    public override func start() {
        
        //        TODO: Remove , set for test
        guard !isTestAndOpenDetails else {
                    Task {
                        guard let transfer = try? await TransferMockData().fetchTransfers(page: 1).first else { return}
                        showTransfersDetails(transfer: transfer)
                    }
            return
        }
        
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

