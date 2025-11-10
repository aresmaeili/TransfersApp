//
//  SortOption.swift
//  TransferFeature
//
//  Created by AREM on 10/31/25.
//

// MARK: - SortOption

enum SortOption: String, CaseIterable {
    case none = "None"
    case nameAscending = "Name Asc"
    case nameDescending = "Name Desc"

    case amountAscending = "Amount Asc"
    case amountDescending = "Amount Desc"
}

// MARK: - Helpers

extension SortOption {
    
    var displayName: String {
        switch self {
        case .none: return "No Sort"
        case .nameAscending: return "Name (A–Z)"
        case .nameDescending: return "Name (Z–A)"
        case .amountAscending: return "Amount (Low–High)"
        case .amountDescending: return "Amount (High–Low)"
        }
    }
}
