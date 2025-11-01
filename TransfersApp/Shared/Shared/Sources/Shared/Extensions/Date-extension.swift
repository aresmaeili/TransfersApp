//
//  Date-extension.swift
//  Shared
//
//  Created by AREM on 10/31/25.
//

import Foundation

public extension Date {
    /// Converts a Date to a human-readable string (localized)
    func toDateString(dateStyle: DateFormatter.Style, timeStyle: DateFormatter.Style ) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = dateStyle
        formatter.timeStyle = timeStyle
        formatter.locale = .current
        formatter.timeZone = .current
        return formatter.string(from: self)
    }
}
