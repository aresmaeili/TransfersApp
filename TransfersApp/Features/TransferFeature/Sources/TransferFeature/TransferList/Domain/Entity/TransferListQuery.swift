//
//  TransferListQuery.swift
//  TransferFeature
//
//  Created by AREM on 10/31/25.
//


import Foundation

/// A structure defining the current criteria for filtering and sorting transfers.
struct TransferListQuery {
    let textSearch: String
    let sortOption: SortOption
}
