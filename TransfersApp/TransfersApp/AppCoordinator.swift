//
//  AppCoordinator.swift
//  TransfersApp
//
//  Created by AREM on 10/30/25.
//
import UIKit
import RouterCore
import TransferFeature

final class AppCoordinator: BaseCoordinator {
    
    var isTesting: Bool {
        return true
    }
    
    override func start() {
        showTransferFeature()
    }
    
    
    private func showTransferFeature() {
        let transferCoordinator = TransferCoordinator(navigationController: navigationController)
        add(child: transferCoordinator)
        transferCoordinator.start()
    }
    
    private func testFeature() {
        let transferCoordinator = TransferCoordinator(navigationController: navigationController)
        add(child: transferCoordinator)
        transferCoordinator.start()
    }
}

