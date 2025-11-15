//
//  NavigationRouter.swift
//  RouterCore
//
//  Created by AREM on 11/9/25.
//

import UIKit

@MainActor
public final class NavigationRouter: Router {

    private unowned let navigationController: UINavigationController

    public init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    public func setRoot(_ vc: UIViewController, hideBar: Bool = false) {
        navigationController.setViewControllers([vc], animated: false)
        navigationController.isNavigationBarHidden = hideBar
    }

    public func push(_ vc: UIViewController, animated: Bool = true) {
        navigationController.pushViewController(vc, animated: animated)
    }

    public func pop(animated: Bool = true) {
        navigationController.popViewController(animated: animated)
    }

    public func popToRoot(animated: Bool = true) {
        navigationController.popToRootViewController(animated: animated)
    }

    public func present(_ vc: UIViewController, style: PresentationStyle = .half, animated: Bool = true, completion: (() -> Void)? = nil) {
        configurePresentation(for: vc, style: style)
        let presenter = navigationController.visibleViewController ?? navigationController
        presenter.present(vc, animated: animated, completion: completion)
    }

    public func dismiss(animated: Bool = true, completion: (() -> Void)? = nil) {
        let presenter = navigationController.visibleViewController ?? navigationController
        presenter.dismiss(animated: animated, completion: completion)
    }

    private func configurePresentation(for vc: UIViewController, style: PresentationStyle) {
        switch style {
        case .full:
            vc.modalPresentationStyle = .fullScreen

        case .half:
            if #available(iOS 15.0, *),
               let sheet = vc.sheetPresentationController {
                sheet.detents = [.medium(), .large()]
                sheet.preferredCornerRadius = 16
            } else {
                vc.modalPresentationStyle = .pageSheet
                vc.preferredContentSize = CGSize(
                    width: UIScreen.main.bounds.width,
                    height: UIScreen.main.bounds.width / 2
                )
            }

        case .fixed(let height):
            vc.modalPresentationStyle = .pageSheet
            vc.preferredContentSize = CGSize(
                width: UIScreen.main.bounds.width,
                height: height
            )
        }
    }
}
