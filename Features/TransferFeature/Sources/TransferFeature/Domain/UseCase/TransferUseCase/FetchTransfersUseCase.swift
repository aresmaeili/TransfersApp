//
//  DefaultFetchTransfersUseCase.swift
//  TransferFeature
//
//  Created by AREM on 11/1/25.
//

import Foundation

// MARK: - FetchTransfersUseCaseProtocol

//protocol FetchTransfersUseCaseProtocol {
//    var filteredTransfers: [Transfer] { get }
//    var transfers: [Transfer] { get }
//    func fetchTransfers(page: Int) async throws
//    func sortTransfers(_ transfers: [Transfer], by option: SortOption) -> [Transfer]
//    func getfilteredTransfersItem(index: Int) -> Transfer?
//    func getFirstTransfersItem(index: Int) -> Transfer?
//    func loadNextPageIfNeeded(currentItem: Transfer?, isLoading: Bool) async throws
//    func refreshTransfers() async throws
//    func changeSortOption(_ option: SortOption)
//    func getSortOption() -> SortOption
//    func chancChangeSearchText(_ text: String)
//}

protocol FetchTransfersUseCaseProtocol: Sendable {
    
    func fetchTransfers(page: Int) async throws -> [Transfer]
    func mergeTransfers( current: [Transfer]?, new: [Transfer] ) -> [Transfer]
}


// MARK: - FetchTransfersUseCase

final class FetchTransfersUseCase: FetchTransfersUseCaseProtocol {
      
    // MARK: - Dependencies
    
    private let repository: TransferRepositoryProtocol
    
    // MARK: - Initialization
    
    init(repository: TransferRepositoryProtocol) {
        self.repository = repository
    }

    func mergeTransfers(current: [Transfer]?, new: [Transfer]) -> [Transfer] {
        guard var current, !current.isEmpty else { return new }
        current.append(contentsOf: new)
        return current
    }

    // MARK: - FetchTransfersUseCaseProtocol
    
    func fetchTransfers(page: Int) async throws -> [Transfer] {
        try await repository.fetchTransfers(page: page)
    }
}
