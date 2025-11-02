//
//  DateFormatter-extension.swift
//  Shared
//
//  Created by AREM on 10/30/25.
//
import Foundation

public extension String {
    func cached(with format: String) -> DateFormatter {
        // Simple, local cache – suitable for decoding; consider a more robust cache for hot paths.
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.calendar = Calendar(identifier: .gregorian)
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        formatter.dateFormat = format
        return formatter
    }
}
