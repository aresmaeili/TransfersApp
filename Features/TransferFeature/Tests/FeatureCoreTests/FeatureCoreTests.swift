//
//  FeatureCoreTests.swift
//  TransferFeature
//
//  Created by AREM on 11/10/25.
//

import XCTest
@testable import TransferFeature
import UIKit
import RouterCore

final class FeatureCoreTests: XCTestCase {

    @MainActor
    func test_fetchFavorites_returnsAllFavoritesFromRepository() async {
        // Given
        
        let dataSource = TransferMockData()
        let repoTransfer = TransferRepositoryImpl(dataSource: dataSource)
        let transfersUseCase = FetchTransfersUseCase(repository: repoTransfer)
        let repoFavorite = FavoriteRepositoryImpl(dataSource: FavoriteDataSource())
        let favoriteUseCase = FavoriteTransferUseCase(repository: repoFavorite)
        let router = NavigationRouter(navigationController: UINavigationController())
        let vm = TransferListViewModel(fetchTransfersUseCase: transfersUseCase, favoriteUseCase: favoriteUseCase, coordinator: TransferCoordinator(router: router))

        // When
        let fetched = vm.favoriteCount
        try? await Task.sleep(nanoseconds: 300_000_000)

        // Then
        XCTAssertEqual(fetched, 2)
    }

}
