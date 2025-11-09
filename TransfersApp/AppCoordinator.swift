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
    
    override func start() {
        showTransferFeature()
    }
    
    private func showTransferFeature() {
        let transferCoordinator = TransferCoordinator(router: router)
        addChild(transferCoordinator)
        transferCoordinator.start()
    }
}

