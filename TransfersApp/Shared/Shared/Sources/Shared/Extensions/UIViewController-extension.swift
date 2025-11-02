//
//  UITableView-extension.swift
//  Shared
//
//  Created by AREM on 10/31/25.
//
import UIKit

public extension UIViewController {
    func showErrorAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}

public extension UIViewController {
    static func instantiate(from storyboardName: String, bundle: Bundle = .main) -> Self {
        UIStoryboard.instantiate(self, from: storyboardName, bundle: bundle)
    }
}

public extension UIStoryboard {
    static func instantiate<T: UIViewController>(
        _ type: T.Type,
        from name: String,
        bundle: Bundle = .main
    ) -> T {
        let storyboard = UIStoryboard(name: name, bundle: bundle)
        guard let vc = storyboard.instantiateViewController(withIdentifier: String(describing: type)) as? T else {
            preconditionFailure("❌ \(type) not found in \(name).storyboard")
        }
        return vc
    }
}

public extension UIViewController {
    func setLoading(_ show: Bool) {
        DispatchQueue.main.async {
            if show {
                LoadingManager.shared.show(in: self.view)
            } else {
                LoadingManager.shared.hide()
            }
        }
    }
}

public extension UIViewController {
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        present(alert, animated: true)
    }
}
