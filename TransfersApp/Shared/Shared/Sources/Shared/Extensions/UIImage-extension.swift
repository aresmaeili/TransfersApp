//
//  UIImage-extension.swift
//  Shared
//
//  Created by AREM on 11/1/25.
//

import UIKit

public extension UIImage {
    static func shared(named name: String) -> UIImage? {
        return UIImage(named: name, in: .module, compatibleWith: nil)
    }
}
