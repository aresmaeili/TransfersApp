//
//  NavigationRouter.swift
//  RouterCore
//
//  Created by AREM on 11/9/25.
//

import UIKit

public enum PresentationStyle {
    case full
    case half
    case fixed(height: CGFloat)
}

public final class NavigationRouter: Router {

    private weak var navigationController: UINavigationController?

    public init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    public func setRoot(_ vc: UIViewController, hideBar: Bool = false) {
        navigationController?.setViewControllers([vc], animated: false)
        navigationController?.setNavigationBarHidden(hideBar, animated: false)
    }

    public func push(_ vc: UIViewController, animated: Bool = true) {
        navigationController?.pushViewController(vc, animated: animated)
    }

    public func present(_ vc: UIViewController, animated: Bool = true) {
        navigationController?.present(vc, animated: animated)
    }

    public func present(_ vc: UIViewController, style: PresentationStyle = .half, animated: Bool = true) {
        switch style {
        case .full:
            vc.modalPresentationStyle = .fullScreen
        case .half:
            if #available(iOS 15.0, *) {
                if let sheet = vc.sheetPresentationController {
                    sheet.detents = [.medium()]
                }
            } else {
                vc.modalPresentationStyle = .pageSheet
            }
        case .fixed(let height):
                vc.modalPresentationStyle = .pageSheet
                vc.preferredContentSize = CGSize(width: UIScreen.main.bounds.width,
                                                 height: height)
            
        }
        navigationController?.present(vc, animated: animated)
    }

    public func dismiss(animated: Bool = true, completion: (() -> Void)? = nil) {
        navigationController?.dismiss(animated: animated, completion: completion)
    }

    public func pop(animated: Bool = true) {
        navigationController?.popViewController(animated: animated)
    }
}
