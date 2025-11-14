//
//  SortOption.swift
//  TransferFeature
//
//  Created by AREM on 10/31/25.
//

// MARK: - SortOption

enum SortOption: String, CaseIterable {
    case none = "No Sort"
    case nameAscending = "Name (A–Z)"
    case nameDescending = "Name (Z–A)"

    case amountAscending = "Amount (Low–High)"
    case amountDescending = "Amount (High–Low)"
}
