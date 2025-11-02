//
//  TransferRepository.swift
//  TransferFeature
//
//  Created by AREM on 11/1/25.
//


import Foundation

public protocol TransferRepositoryProtocol: Sendable {
    func fetchTransfers(page: Int) async throws -> [Transfer]
}
