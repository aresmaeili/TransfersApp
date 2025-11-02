//
//  BaseCoordinator.swift
//  Router
//
//  Created by AREM on 10/28/25.
//
import UIKit

open class BaseCoordinator: NSObject, Coordinator, CoordinatorDelegate {
    
    public var navigationController: UINavigationController
    public weak var delegate: CoordinatorDelegate?
    
    private var childCoordinators: [Coordinator] = []
    
    public init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    // MARK: Coordinator Methods
    open func start() {
        fatalError("Start method should be implemented in subclass")
    }
    
    public func didFinish() {
        // Notifies the parent coordinator that this flow is complete
        delegate?.coordinatorDidFinish(self)
    }
    
    // MARK: Child Management
    public func add(child coordinator: Coordinator) {
        // Set the child's delegate to self so it can signal when it finishes
        coordinator.delegate = self
        childCoordinators.append(coordinator)
    }
    
    public func remove(child coordinator: Coordinator) {
        childCoordinators.removeAll { $0 === coordinator }
    }
    
    // MARK: CoordinatorDelegate Conformance (Handles child removal)
    public func coordinatorDidFinish(_ coordinator: Coordinator) {
        remove(child: coordinator)
    }
    
    // MARK: Navigation Helpers
    
    public func present(_ viewControllerToPresent: UIViewController, animated flag: Bool, completion: (() -> Void)? = nil) {
        navigationController.present(viewControllerToPresent, animated: flag, completion: completion)
    }
    
    public func dismiss(animated flag: Bool, completion: (() -> Void)? = nil) {
        navigationController.dismiss(animated: flag, completion: completion)
    }
    
    @discardableResult
    public func popViewController(animated: Bool) -> UIViewController? {
        return navigationController.popViewController(animated: animated)
    }
}
