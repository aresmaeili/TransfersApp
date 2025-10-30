//
//  BaseCoordinator.swift
//  Router
//
//  Created by AREM on 10/28/25.
//
import UIKit

open class BaseCoordinator: Coordinator {
    public var navigationController: UINavigationController
    private var childCoordinators: [Coordinator] = []
    
    public init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    open func start() {
        fatalError("Start method should be implemented in subclass")
    }
    
    public func add(child coordinator: Coordinator) {
        childCoordinators.append(coordinator)
    }
    
    func remove(child coordinator: Coordinator) {
        childCoordinators.removeAll { $0 === coordinator }
    }
}
