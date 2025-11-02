//
//  UILabel-extension.swift
//  Shared
//
//  Created by AREM on 11/1/25.
//
import UIKit

public extension UILabel {
    func setCharacterSpacing(_ spacing: CGFloat) {
        guard let text = self.text else { return }
        let attributedString = NSMutableAttributedString(string: text)
        attributedString.addAttribute(.kern, value: spacing, range: NSRange(location: 0, length: text.count))
        self.attributedText = attributedString
    }
}
