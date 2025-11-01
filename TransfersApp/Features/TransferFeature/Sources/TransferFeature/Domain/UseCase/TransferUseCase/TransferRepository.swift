//
//  TransferRepository.swift
//  TransferFeature
//
//  Created by AREM on 11/1/25.
//


import Foundation

protocol TransferRepository: Sendable {
    func fetchTransfers(page: Int) async throws -> [Transfer]
}