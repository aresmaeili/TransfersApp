//
//  String-extension.swift
//  Shared
//
//  Created by AREM on 10/31/25.
//
import Foundation

public extension String {
    /// Converts an ISO8601 string (e.g. "2022-08-31T15:24:16Z") to a Date.
    func toISODate() -> Date? {
        let formatter = ISO8601DateFormatter()
        return formatter.date(from: self)
    }
    
    func toDateShowable(dateStyle: DateFormatter.Style = .short,
                        timeStyle: DateFormatter.Style = .none) -> String? {
        self.toISODate()?.toDateString(dateStyle: dateStyle, timeStyle: timeStyle)
    }

}
