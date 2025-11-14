//
//  Coordinator.swift
//  Router
//
//  Created by AREM on 10/28/25.
//

@MainActor
public protocol Coordinator: AnyObject {
    func start()
    func finish()
}

