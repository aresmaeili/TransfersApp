//
//  TransferAPI.swift
//  TransferFeature
//
//  Created by AREM on 10/30/25.
//

import Foundation
import NetworkCore

// MARK: - TransferDataSource

protocol TransferDataSourceProtocol: Sendable {
    func fetchTransfers(page: Int) async throws -> [Transfer]
}

// MARK: - TransferAPI

final class TransferAPIDataSource: TransferDataSourceProtocol {
    
    // MARK: - Properties
    
    private let client: NetworkClient
    
    // MARK: - Initialization
    
    init(client: NetworkClient = .shared) {
        self.client = client
    }
    
    // MARK: - API Call
    
    func fetchTransfers(page: Int) async throws -> [Transfer] {
        let endpoint = TransferListEndpoint(page: page)
        return try await client.request(endpoint)
    }
}

