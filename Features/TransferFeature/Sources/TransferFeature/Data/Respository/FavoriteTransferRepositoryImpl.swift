//
//  FavoriteTransferRepositoryProtocol.swift
//  TransferFeature
//
//  Created by AREM on 10/31/25.
//

import Foundation

// MARK: - FavoriteRepositoryImpl

 final actor FavoriteRepositoryImpl: FavoriteTransferRepositoryProtocol {

    private let dataSource: FavoriteDataSourceProtocol

    init(dataSource: FavoriteDataSourceProtocol) {
        self.dataSource = dataSource
    }

    func getFavorites() async -> [Transfer] {
        await dataSource.getFavorites()
    }

    func save(_ transfer: Transfer) async {
        await dataSource.save(transfer: transfer)
    }

    func remove(_ transfer: Transfer) async {
        await dataSource.remove(transfer: transfer)
    }

    func contains(_ transfer: Transfer) async -> Bool {
        await dataSource.isFavorite(transfer: transfer)
    }
}
