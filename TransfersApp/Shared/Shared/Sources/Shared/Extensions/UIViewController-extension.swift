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

