//
//  TransferAPI.swift
//  TransferFeature
//
//  Created by AREM on 10/30/25.
//


import Foundation
import NetworkCore

protocol TransferDataSource: Sendable {
    func fetchTransfers() async throws -> [Transfer]
}

final class TransferAPI: TransferDataSource {
    func fetchTransfers() async throws -> [Transfer] {
        let endpoint = TransferListEndpoint()
        let result: [Transfer] = try await NetworkClient.shared.get(endPoint: endpoint)
        return result
    }
}
