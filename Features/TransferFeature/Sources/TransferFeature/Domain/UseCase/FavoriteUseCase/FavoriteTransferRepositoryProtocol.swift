//
//  FavoriteTransferRepositoryProtocol.swift
//  TransferFeature
//
//  Created by AREM on 11/1/25.
//

import Foundation

protocol FavoriteTransferRepositoryProtocol: Sendable {
    func getFavorites() async -> [Transfer]
    func save(_ transfer: Transfer) async
    func remove(_ transfer: Transfer) async
    func contains(_ transfer: Transfer) async -> Bool
    }
