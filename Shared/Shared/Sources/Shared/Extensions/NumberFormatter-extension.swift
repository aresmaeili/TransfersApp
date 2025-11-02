//
//  NumberFormatter-extension.swift
//  Shared
//
//  Created by AREM on 11/1/25.
//

import Foundation

public extension NumberFormatter {
    static let money: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return formatter
    }()

    static func moneyString(from value: Double) -> String {
        if let formatted = money.string(from: NSNumber(value: value)) {
            return "$\(formatted)"
        }
        return "-"
    }
    
    static func seperatedString(from value: Double) -> String {
        if let formatted = money.string(from: NSNumber(value: value)) {
            return "\(formatted)"
        }
        return "-"
    }
}
