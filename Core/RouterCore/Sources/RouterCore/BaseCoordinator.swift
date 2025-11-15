//
//  BaseCoordinator.swift
//  Router
//
//  Created by AREM on 10/28/25.
//

import UIKit

@MainActor
public protocol Coordinator: AnyObject {
    func start()
    func finish()
}

@MainActor
open class BaseCoordinator: Coordinator {

    public weak var parent: BaseCoordinator?
    public private(set) var childCoordinators: [BaseCoordinator] = []

    public let router: Router

    public init(router: Router) {
        self.router = router
    }

    // MARK: - Lifecycle
    open func start() {
        fatalError("start() must be overridden in subclass")
    }

    open func finish() {
        parent?.removeChild(self)
    }

    // MARK: - Child management
    public func addChild(_ coordinator: BaseCoordinator) {
        guard !childCoordinators.contains(where: { $0 === coordinator }) else { return }
        coordinator.parent = self
        childCoordinators.append(coordinator)
    }

    public func removeChild(_ coordinator: BaseCoordinator) {
        childCoordinators.removeAll { $0 === coordinator }
    }

    deinit {
        print("Deinit Coordinator: \(Self.self)")
    }
}
