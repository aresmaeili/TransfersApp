//
//  TransferAPI.swift
//  TransferFeature
//
//  Created by AREM on 10/30/25.
//

import Foundation
import NetworkCore

// MARK: - TransferDataSource

/// A protocol defining a common interface for fetching transfer data.
/// Both live APIs and mock data sources should conform to this.
protocol TransferDataSource: Sendable {
    func fetchTransfers(page: Int) async throws -> [Transfer]
}

// MARK: - TransferAPI

/// Handles network calls for fetching transfer data from a remote API.
final class TransferAPI: TransferDataSource {
    
    // MARK: - Properties
    
    private let client: NetworkClient
    
    // MARK: - Initialization
    
    init(client: NetworkClient = .shared) {
        self.client = client
    }
    
    // MARK: - API Call
    
    func fetchTransfers(page: Int) async throws -> [Transfer] {
        let endpoint = TransferListEndpoint(page: page)
        return try await client.get(endPoint: endpoint)
    }
}
