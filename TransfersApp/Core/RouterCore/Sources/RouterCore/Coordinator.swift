//
//  Coordinator.swift
//  Router
//
//  Created by AREM on 10/28/25.
//
import UIKit

// MARK: - Delegate Protocol
@MainActor
public protocol CoordinatorDelegate: AnyObject {
    func coordinatorDidFinish(_ coordinator: Coordinator)
}

// MARK: - Main Protocol
@MainActor
public protocol Coordinator: AnyObject {
    var navigationController: UINavigationController { get }
    var delegate: CoordinatorDelegate? { get set } // Added delegate
    
    func start()
    func didFinish() // Added method to signal completion
}
