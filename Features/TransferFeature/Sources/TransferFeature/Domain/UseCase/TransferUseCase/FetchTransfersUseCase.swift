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
    
    func filterAndSort( _ transfers: [Transfer], searchText: String, sortOption: SortOption) -> [Transfer]
    
    func mergeTransfers( current: [Transfer]?, new: [Transfer] ) -> [Transfer]
}


// MARK: - FetchTransfersUseCase

final class FetchTransfersUseCase: FetchTransfersUseCaseProtocol {
    
    func filterAndSort( _ transfers: [Transfer], searchText: String, sortOption: SortOption) -> [Transfer] {
        let searched = searchText.isEmpty
        ? transfers
        : transfers.filter { $0.name.localizedCaseInsensitiveContains(searchText) }
        
        return sortTransfers(searched, by: sortOption)
    }
    
    func mergeTransfers(current: [Transfer]?, new: [Transfer]) -> [Transfer] {
        guard var current, !current.isEmpty else { return new }
        current.append(contentsOf: new)
        return current
    }
    
    private func sortTransfers(_ transfers: [Transfer], by option: SortOption) -> [Transfer] {
        switch option {
        case .nameAscending:
            return transfers.sorted { $0.name.localizedCaseInsensitiveCompare($1.name) == .orderedAscending }
        case .nameDescending:
            return transfers.sorted { $0.name.localizedCaseInsensitiveCompare($1.name) == .orderedDescending }
        case .dateAscending:
            return transfers.sorted { $0.date < $1.date }
        case .dateDescending:
            return transfers.sorted { $0.date > $1.date }
        case .amountAscending:
            return transfers.sorted { $0.amount < $1.amount }
        case .amountDescending:
            return transfers.sorted { $0.amount > $1.amount }
        case .none:
            return transfers
        }
    }
    // MARK: - Dependencies
    
    private let repository: TransferRepositoryProtocol
    
    // MARK: - Initialization
    
    init(repository: TransferRepositoryProtocol) {
        self.repository = repository
    }
    
    // MARK: - FetchTransfersUseCaseProtocol
    
    func fetchTransfers(page: Int) async throws -> [Transfer] {
        try await repository.fetchTransfers(page: page)
    }
}
