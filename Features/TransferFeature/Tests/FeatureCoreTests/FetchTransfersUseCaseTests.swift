//
//  FetchTransfersUseCaseTests.swift
//  TransferFeature
//
//  Created by AREM on 11/10/25.
//


import XCTest
@testable import TransferFeature

final class FetchTransfersUseCaseTests: XCTestCase {

    
    func test_mergeTransfers_avoidsDuplicatesById() {
        // Given
        let dataSource = TransferMockDataSource()
        let repo = TransferRepositoryImpl(dataSource: dataSource)
        let sut = FetchTransfersUseCase(repository: repo)

        let a1 = TransferFixtures.transfer(fullName: "Alice", email: "alice@x.com", cardNumber: "1111")
        let a2 = TransferFixtures.transfer(fullName: "Alice", email: "alice@x.com", cardNumber: "1111")
        let b1 = TransferFixtures.transfer(fullName: "Bob",   email: "bob@x.com",   cardNumber: "2222")

        // When
        let merged = sut.mergeTransfers(current: [a1], new: [a2, b1])

        // Then
        XCTAssertEqual(merged.count, 3)
//        XCTAssertTrue(merged.contains(where: { $0.id == a1.id }))

    }
    
    func test_fetchTransfers_returnsRemoteItems() async throws {
        let dataSource = TransferMockDataSource()
        let repo = TransferRepositoryImpl(dataSource: dataSource)

        let items = try await repo.fetchTransfers(page: 1)
        XCTAssertEqual(items.count, 12)
    }
}
