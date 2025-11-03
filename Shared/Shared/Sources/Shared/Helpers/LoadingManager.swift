//
//  LoadingManager.swift
//  Shared
//
//  Created by AREM on 11/1/25.
//
import UIKit

@MainActor
public final class LoadingManager {

     public static let shared = LoadingManager()
    private var loadingView: LoadingView?

    private init() {}

    public func show(in view: UIView?) {
        guard let container = view, loadingView == nil else { return }

        let loading = LoadingView(frame: container.bounds)
        loading.show(in: container)
        loadingView = loading
    }

    public func hide() {
        loadingView?.hide()
        loadingView = nil
    }
}
