//
//  TransferListViewModelTests.swift
//  TransferFeature
//
//  Created by AREM on 11/10/25.
//

import XCTest
@testable import TransferFeature
import RouterCore

@MainActor
final class TransferListViewModelTests: XCTestCase {
    

    func test_refreshTransfers_loadsFirstPageAndUpdatesList() async {
        // Given
        let dataSource = TransferMockDataSource()
        let repoTransfer = TransferRepositoryImpl(dataSource: dataSource)
        let transfersUseCase = FetchTransfersUseCase(repository: repoTransfer)
        let repoFavorite = FavoriteRepositoryImpl(dataSource: FavoriteDataSource())
        let favoriteUseCase = FavoriteTransferUseCase(repository: repoFavorite)
        let router = NavigationRouter(navigationController: UINavigationController())
        let vm = TransferListViewModel(fetchTransfersUseCase: transfersUseCase, favoriteUseCase: favoriteUseCase, coordinator: TransferCoordinator(router: router))
        
        let transfer = vm.refreshTransfers()
        try? await Task.sleep(nanoseconds: 2000_000_000)

        // Then
        XCTAssertEqual(vm.transfersCount, 12)
        XCTAssertEqual(vm.getTransferItem(at: 0)?.person?.fullName ?? "", "Alice 1 Johnson")
    }
    
    func test_loadNextPageIfNeeded_fetchesNextPage_whenNearEndOfList() async {
        
        let dataSource = TransferMockDataSource()
        let repoTransfer = TransferRepositoryImpl(dataSource: dataSource)
        let transfersUseCase = FetchTransfersUseCase(repository: repoTransfer)
        let repoFavorite = FavoriteRepositoryImpl(dataSource: FavoriteDataSource())
        let favoriteUseCase = FavoriteTransferUseCase(repository: repoFavorite)
        let router = NavigationRouter(navigationController: UINavigationController())
        let vm = TransferListViewModel(fetchTransfersUseCase: transfersUseCase, favoriteUseCase: favoriteUseCase, coordinator: TransferCoordinator(router: router))

        vm.refreshTransfers()
        try? await Task.sleep(nanoseconds: 200_000_000)

  
        // When
        vm.loadNextPageIfNeeded(currentItem: vm.getTransferItem(at: 2))

        try? await Task.sleep(nanoseconds: 300_000_000)

        // Then
        XCTAssertEqual(vm.transfersCount, 12)
        XCTAssertTrue(vm.filteredTransfers.contains { $0.name.contains("Alice 1 Johnson") })
    }
}
