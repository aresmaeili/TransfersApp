//
//  UIStackView-extension.swift
//  Shared
//
//  Created by AREM on 11/2/25.
//
import UIKit

public extension UIStackView {
    func removeAllArrangedSubviews() {
        let removedSubviews = arrangedSubviews
        
        removedSubviews.forEach { subview in
            self.removeArrangedSubview(subview)
            NSLayoutConstraint.deactivate(subview.constraints)
            subview.removeFromSuperview()
        }
    }
}
