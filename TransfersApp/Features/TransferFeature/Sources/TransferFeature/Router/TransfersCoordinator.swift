//
//  TransfersCoordinator.swift
//  TransferFeature
//
//  Created by AREM on 10/30/25.
//
import UIKit
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
    private let factory: TransferFactory
    
    // MARK: - Initialization
    public init(
        navigationController: UINavigationController, transferRepository: TransferRepositoryProtocol? = nil, favoriteRepository: FavoriteTransferRepositoryProtocol? = nil) {
        let transferRepository = transferRepository ?? TransferRepositoryImpl(dataSource: TransferMockData())
        let favoriteRepository = favoriteRepository ?? FavoriteRepositoryImpl()
        self.factory = TransferFactory(transferRepository: transferRepository, favoriteRepository: favoriteRepository)
        
        super.init(navigationController: navigationController)
    }
    
    // MARK: - Lifecycle
    public override func start() {
        showTransfersList()
    }
    
    // MARK: - Routing
    private func showTransfersList() {
        let viewController = factory.makeTransferListModule(router: self)
        navigationController.pushViewController(viewController, animated: true)
    }
    
    public func showTransfersDetails(transfer: Transfer) {
        let viewController = factory.makeTransferDetailsModule(transfer: transfer)
        navigationController.pushViewController(viewController, animated: true)
    }
}
