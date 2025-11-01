//
//  Double-extension.swift
//  Shared
//
//  Created by AREM on 11/1/25.
//

import Foundation

public extension Double {
    func asMoneyString() -> String {
        return NumberFormatter.moneyString(from: self)
    }
    
    func asSeperatedString() -> String {
        return NumberFormatter.moneyString(from: Double(self))
    }
}


