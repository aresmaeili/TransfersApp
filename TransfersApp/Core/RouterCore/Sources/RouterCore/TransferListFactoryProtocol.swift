//
//  TransferListFactoryProtocol.swift
//  RouterCore
//
//  Created by AREM on 10/30/25.
//

import UIKit

@MainActor
public protocol VCFactoryProtocol {
    func makeModule(navigation: UINavigationController) -> UIViewController
}
