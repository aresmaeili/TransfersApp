//
//  Coordinator.swift
//  Router
//
//  Created by AREM on 10/28/25.
//


import UIKit

@MainActor
public protocol Coordinator: AnyObject {
    var navigationController: UINavigationController { get }
    func start()
}

