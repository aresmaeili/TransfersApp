//
//  UIViewController+Extensions.swift
//  Shared
//
//  Created by AREM on 10/31/25.
//

import UIKit

// MARK: - UIViewController Alerts

public extension UIViewController {
    
    /// Displays a simple error alert with a title and message.
    func showErrorAlert(title: String, message: String) {
        showAlert(title: title, message: message)
    }
    
    /// Displays a generic alert with a title and message.
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}

// MARK: - UIViewController Instantiation

public extension UIViewController {
    
    /// Instantiates a view controller from a storyboard with the same identifier as its class name.
    static func instantiate(from storyboardName: String, bundle: Bundle = .main) -> Self {
        UIStoryboard.instantiate(self, from: storyboardName, bundle: bundle)
    }
}

// MARK: - UIStoryboard Helper

public extension UIStoryboard {
    
    /// Instantiates a view controller of the specified type from the given storyboard.
    static func instantiate<T: UIViewController>( _ type: T.Type, from name: String, bundle: Bundle = .main ) -> T {
        let storyboard = UIStoryboard(name: name, bundle: bundle)
        guard let vc = storyboard.instantiateViewController(withIdentifier: String(describing: type)) as? T else {
            preconditionFailure("❌ \(type) not found in \(name).storyboard")
        }
        return vc
    }
}

// MARK: - Loading Indicator

public extension UIViewController {
    
    /// Shows or hides a global loading view.
    func setLoading(_ show: Bool) {
        DispatchQueue.main.async {
            show ? LoadingManager.shared.show(in: self.view)
                 : LoadingManager.shared.hide()
        }
    }
}
