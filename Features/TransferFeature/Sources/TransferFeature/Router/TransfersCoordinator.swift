//
//  TransfersCoordinator.swift
//  TransferFeature
//
//  Created by AREM on 10/30/25.
//
import Foundation
import RouterCore

// MARK: - Router Protocol
@MainActor
public protocol TransferRouter: AnyObject {
    func showTransfersDetails(transfer: Transfer)
}

// MARK: - Coordinator
@MainActor
public final class TransferCoordinator: BaseCoordinator, TransferRouter {
    
    // MARK: - Dependencies
    private let factory: TransferFactoryProtocol
    
    // MARK: - Initialization
    public override init(router: Router) {
        self.factory = TransferVCFactory()
        super.init(router: router)
    }
    
    // MARK: - Lifecycle
    public override func start() {
        showTransfersList()
    }
    
    // MARK: - Routing
    private func showTransfersList() {
        let viewController = factory.makeTransferListModule(coordinator: self)
        router.push(viewController, animated: true)
    }
    
    public func showTransfersDetails(transfer: Transfer) {
        let viewController = factory.makeTransferDetailsModule(transfer: transfer)
        router.push(viewController, animated: true)
    }
}
