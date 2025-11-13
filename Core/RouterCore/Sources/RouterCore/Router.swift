//
//  Router.swift
//  RouterCore
//
//  Created by AREM on 11/9/25.
//


import UIKit

@MainActor
public protocol Router: AnyObject {
    func push(_ vc: UIViewController, animated: Bool)
    func present(_ vc: UIViewController, animated: Bool)
    func present(_ vc: UIViewController, style: PresentationStyle, animated: Bool)
    func dismiss(animated: Bool, completion: (() -> Void)?)
    func pop(animated: Bool)
}
