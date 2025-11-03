//
//  ViewConnectable.swift
//  Shared
//
//  Created by AREM on 11/1/25.
//

import UIKit

// MARK: - ViewConnectable

/// A protocol that allows a UIView to automatically connect its corresponding XIB file.
@MainActor
public protocol ViewConnectable {
    func connectView(bundle: Bundle?)
}

// MARK: - Default Implementation

public extension ViewConnectable where Self: UIView {
    
    /// Connects the view to its matching XIB file by class name.
    func connectView(bundle: Bundle?) {
        let nibName = resolvedNibName()
        let nib = UINib(nibName: nibName, bundle: bundle)
        
        guard let view = nib.instantiate(withOwner: self, options: nil).first as? UIView else {
            preconditionFailure("❌ Failed to load nib for \(nibName)")
        }
        
        addFullSizeSubview(view)
    }
    
    // MARK: - Helpers
    
    /// Handles generic class names (e.g., `CardView<T>` → `CardView`).
    private func resolvedNibName() -> String {
        var name = String(describing: Self.self)
        if let genericTypeRange = name.range(of: "<") {
            name.removeSubrange(genericTypeRange.lowerBound..<name.endIndex)
        }
        return name
    }
}

// MARK: - UIView Helper

public extension UIView {
    
    /// Adds a subview that fully fills its parent using Auto Layout.
    func addFullSizeSubview(_ view: UIView, fixedHeight: CGFloat? = nil) {
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        
        NSLayoutConstraint.activate([
            view.topAnchor.constraint(equalTo: topAnchor),
            view.bottomAnchor.constraint(equalTo: bottomAnchor),
            view.leadingAnchor.constraint(equalTo: leadingAnchor),
            view.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
        
        if let fixedHeight, fixedHeight > 0 {
            view.heightAnchor.constraint(equalToConstant: fixedHeight).isActive = true
        }
    }
}
