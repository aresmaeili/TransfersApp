//
//  Router.swift
//  RouterCore
//
//  Created by AREM on 11/9/25.
//

import UIKit

@MainActor
public protocol Router: AnyObject {
    func setRoot(_ vc: UIViewController, hideBar: Bool)
    func push(_ vc: UIViewController, animated: Bool)
    func pop(animated: Bool)
    func popToRoot(animated: Bool)
    
    func present(_ vc: UIViewController, style: PresentationStyle, animated: Bool, completion: (() -> Void)?)
    
    func dismiss(animated: Bool, completion: (() -> Void)?)
}

public enum PresentationStyle {
    case full
    case half
    case fixed(height: CGFloat)
}
