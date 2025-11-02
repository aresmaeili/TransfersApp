//
//  Int-extension.swift
//  Shared
//
//  Created by AREM on 11/1/25.
//

import Foundation

public extension Int {
    func asMoneyString() -> String {
        return NumberFormatter.moneyString(from: Double(self))
    }
    
    func asSeperatedString() -> String {
        return NumberFormatter.seperatedString(from: Double(self))
    }
}

