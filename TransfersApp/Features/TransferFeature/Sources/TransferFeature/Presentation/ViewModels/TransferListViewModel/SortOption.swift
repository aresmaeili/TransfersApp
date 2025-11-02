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
    case dateAscending = "Date Asc"
    case dateDescending = "Date Desc"
    case amountAscending = "Amount Asc"
    case amountDescending = "Amount Desc"
}

// MARK: - Helpers

extension SortOption {
    
    /// User-friendly display name for UI labels or menus.
    var displayName: String {
        switch self {
        case .none: return "No Sort"
        case .nameAscending: return "Name (A–Z)"
        case .nameDescending: return "Name (Z–A)"
        case .dateAscending: return "Date (Oldest First)"
        case .dateDescending: return "Date (Newest First)"
        case .amountAscending: return "Amount (Low–High)"
        case .amountDescending: return "Amount (High–Low)"
        }
    }
    
    /// Indicates whether the sort is ascending.
    var isAscending: Bool {
        switch self {
        case .nameAscending, .dateAscending, .amountAscending:
            return true
        default:
            return false
        }
    }
}
