//
//  TransferListViewModel.swift
//  TransferFeature
//
//  Created by AREM on 10/30/25.
//

import Foundation

// MARK: - Input Protocol
@MainActor
protocol TransferListViewModelInput {
    func toggleFavoriteStatus(for transfer: Transfer)
    func toggleCanEdit()
    func getTransfer(at index: Int) -> Transfer?
    func getFavorite(at index: Int) -> Transfer?
    func getFavoriteTransfer(at index: Int) -> Transfer?
    func getFavorites() -> [Transfer]
    func checkIsFavorite(_ transfer: Transfer) -> Bool
    func loadNextPageIfNeeded(currentItem: Transfer?)
    func refreshTransfers()
    func numberOfRows(in section: Int) -> Int
    func routeToDetails(for transfer: Transfer)
    var textSearch: String { get set }
    var sortOption: SortOption { get set }
}

// MARK: - Output Protocol
@MainActor
protocol TransferListViewModelOutput: AnyObject {

}

// MARK: - ViewModel Implementation
@MainActor
final class TransferListViewModel: TransferListViewModelInput, TransferListViewModelOutput {
    
    // MARK: - Dependencies
    private let fetchTransfersUseCase: FetchTransfersUseCaseProtocol
    private let favoriteUseCase: FavoriteTransferUseCaseProtocol
    private let router: TransferCoordinator
    
    // MARK: - Outputs
    var onUpdate: (() -> Void)?
    var onErrorOccurred: ((String) -> Void)?
    var onLoadingStateChange: ((Bool) -> Void)?
    
    // MARK: - Initialization
    init(
        fetchTransfersUseCase: FetchTransfersUseCaseProtocol,
        favoriteUseCase: FavoriteTransferUseCaseProtocol,
        router: TransferCoordinator
    ) {
        self.fetchTransfersUseCase = fetchTransfersUseCase
        self.favoriteUseCase = favoriteUseCase
        self.router = router
    }
    
    // MARK: - State
    private var currentPage = 1
    private var hasReachedEnd = false
    private(set) var canEdit = false
    
    private(set) var isLoading = false {
        didSet { onLoadingStateChange?(isLoading) }
    }
    
    private(set) var transfers: [Transfer] = [] {
        didSet { onUpdate?() }
    }
    
    // MARK: - Input Properties
    var textSearch: String = "" {
        didSet { onUpdate?() }
    }
    
    var sortOption: SortOption = .serverSort {
        didSet { onUpdate?() }
    }
    
    // MARK: - Computed Properties
    private var allFavorites: [Transfer] { favoriteUseCase.fetchFavorites().reversed() }
    
    var transfersCount: Int { transfers.count }
    var favoritesCount: Int { allFavorites.count }
    
    var hasFavoriteRow: Bool {
        let hasFavorite: Bool = !allFavorites.isEmpty
        if !hasFavorite {
            canEdit = false
        }
        return hasFavorite
    }
    
    var filteredTransfers: [Transfer] {
        let searched = textSearch.isEmpty
            ? transfers
            : transfers.filter { $0.name.localizedCaseInsensitiveContains(textSearch) }
        
        return sortTransfers(searched, by: sortOption)
    }
    
    var filteredTransfersCount: Int { filteredTransfers.count }
    
    // MARK: - Data Fetching
    private func fetchTransfers(page: Int) {
        guard !isLoading else { return }
        
        Task { @MainActor in
            isLoading = true
            defer { isLoading = false }
            
            do {
                let newTransfers = try await fetchTransfersUseCase.fetchTransfers(page: page)
                
                guard !newTransfers.isEmpty else {
                    hasReachedEnd = true
                    print("No more transfers to load.")
                    return
                }
                
                transfers = (page == 1)
                    ? newTransfers
                    : appendUniqueTransfers(current: transfers, new: newTransfers)
                
                currentPage = page
                print("✅ Page \(page) loaded (\(transfers.count) transfers)")
                
            } catch {
                onErrorOccurred?(error.localizedDescription)
            }
        }
    }
    
    // MARK: - Actions
    func toggleFavoriteStatus(for transfer: Transfer) {
        favoriteUseCase.toggleFavoriteStatus(transfer: transfer)
        onUpdate?()
    }
    
    func getTransfer(at index: Int) -> Transfer? { filteredTransfers[safe: index] }
    func getFavorite(at index: Int) -> Transfer? { allFavorites[safe: index] }
    
    func getFavoriteTransfer(at index: Int) -> Transfer? {
        guard let favorite = allFavorites[safe: index],
              let transfer = transfers.first(where: { $0 == favorite }) else {
            onErrorOccurred?("Transfer not found in list.")
            return nil
        }
        return transfer
    }
    
    func getFavorites() -> [Transfer] { allFavorites.reversed() }
    
    func checkIsFavorite(_ transfer: Transfer) -> Bool {
        allFavorites.contains(where: { $0.id == transfer.id })
    }
    
    func loadNextPageIfNeeded(currentItem: Transfer?) {
        guard let currentItem, !isLoading, !hasReachedEnd else { return }
        guard let currentIndex = filteredTransfers.firstIndex(where: { $0.id == currentItem.id }) else { return }
        
        let thresholdIndex = filteredTransfers.index(filteredTransfers.endIndex, offsetBy: -2)
        if currentIndex >= thresholdIndex { fetchTransfers(page: currentPage + 1) }
    }
    
    func refreshTransfers() {
        currentPage = 1
        transfers.removeAll()
        hasReachedEnd = false
        fetchTransfers(page: currentPage)
    }
    
    func numberOfRows(in section: Int) -> Int {
        switch section {
        case 0: return hasFavoriteRow ? 1 : 0
        case 1: return filteredTransfersCount
        default: return 0
        }
    }
    
    func routeToDetails(for transfer: Transfer) {
        router.showTransfersDetails(transfer: transfer)
    }
    
    func toggleCanEdit() {
        canEdit.toggle()
    }
    
    // MARK: - Private Helpers
    private func appendUniqueTransfers(current: [Transfer], new: [Transfer]) -> [Transfer] {
        let existingIDs = Set(current.map(\.id))
        let uniqueNew = new.filter { !existingIDs.contains($0.id) }
        return current + uniqueNew
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
        case .serverSort:
            return transfers
        }
    }
}
