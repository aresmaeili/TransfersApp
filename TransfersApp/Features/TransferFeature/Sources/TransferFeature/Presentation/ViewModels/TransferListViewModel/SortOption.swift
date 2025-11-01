//
//  SortOption.swift
//  TransferFeature
//
//  Created by AREM on 10/31/25.
//

// MARK: - SortOption
enum SortOption: String, CaseIterable {
    case serverSort = "None"
    case nameAscending = "Name Asc"
    case nameDescending = "Name Desc"
    case dateAscending = "Date Asc"
    case dateDescending = "Date Desc"
    case amountAscending = "Amount Asc"
    case amountDescending = "Amount Desc"
}
