//
//  UIView-extension.swift
//  Shared
//
//  Created by AREM on 11/1/25.
//
import UIKit

public extension UIView {
    
    private static var loadingViewKey: UInt8 = 0

    private var loadingView: UIView? {
        get { objc_getAssociatedObject(self, &UIView.loadingViewKey) as? UIView }
        set { objc_setAssociatedObject(self, &UIView.loadingViewKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
    }
    
    func showLoading() {
        // Ensure we are updating the UI on the main thread
        let updateUI = {
            guard self.loadingView == nil else { return }

            let overlay = UIView(frame: self.bounds)
            overlay.backgroundColor = UIColor(white: 0, alpha: 0.4)
            overlay.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            overlay.isUserInteractionEnabled = true

            let spinner = UIActivityIndicatorView(style: .large)
            spinner.translatesAutoresizingMaskIntoConstraints = false
            spinner.startAnimating()
            overlay.addSubview(spinner)

            self.addSubview(overlay)

            NSLayoutConstraint.activate([
                spinner.centerXAnchor.constraint(equalTo: overlay.centerXAnchor),
                spinner.centerYAnchor.constraint(equalTo: overlay.centerYAnchor)
            ])

            self.loadingView = overlay
            self.isUserInteractionEnabled = false
        }

        if Thread.isMainThread {
            updateUI()
        } else {
            OperationQueue.main.addOperation(updateUI)
        }
    }

    func hideLoading() {
        let removeUI = {
            self.loadingView?.removeFromSuperview()
            self.loadingView = nil
            self.isUserInteractionEnabled = true
        }

        if Thread.isMainThread {
            removeUI()
        } else {
            OperationQueue.main.addOperation(removeUI)
        }
    }
}

private actor GestureStorage {
    static let shared = GestureStorage()
    private var storage: [ObjectIdentifier: [AnyObject]] = [:]
    
    func retain(_ handler: AnyObject, for view: UIView) {
        let id = ObjectIdentifier(view)
        if storage[id] != nil {
            storage[id]?.append(handler)
        } else {
            storage[id] = [handler]
        }
    }
}

final class TapGestureHandler: NSObject {
    let action: () -> Void
    init(action: @escaping () -> Void) {
        self.action = action
    }

    @objc func handleTap() {
        action()
    }
}

public extension UIView {
    func onTap(numberOfTaps: Int = 1, _ action: @escaping () -> Void) {
        isUserInteractionEnabled = true

        let handler = TapGestureHandler(action: action)
        let gesture = UITapGestureRecognizer(target: handler, action: #selector(handler.handleTap))
        gesture.numberOfTapsRequired = numberOfTaps
        addGestureRecognizer(gesture)

        Task {
            await GestureStorage.shared.retain(handler, for: self)
        }
    }
}
