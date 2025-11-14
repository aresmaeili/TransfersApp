//
//  TransferListViewModel.swift
//  TransferFeature
//
//  Created by AREM on 10/30/25.
//

import Foundation
import Shared

// MARK: - Input Protocol
protocol TransferListViewModelProtocol: TransferListViewModelInput, TransferListViewModelOutput, AnyObject {}

@MainActor
protocol TransferListViewModelInput: AnyObject {
    var onUpdate: (() -> Void)? { get set }
    var onErrorOccurred: ((String) -> Void)? { get set }
    var onLoadingStateChange: ((Bool) -> Void)? { get set }
    var canEdit: Bool { get }
    var favoriteCounts: Int { get }
    
    func loadFavorites()
    func getFavoriteTransfer(at index: Int) -> Transfer?
    func getFavorite(at index: Int) -> Transfer?
    func toggleFavoriteStatus(for transfer: Transfer)
    func removeItems(item: Transfer)
    func routeToDetails(for transfer: Transfer)
}

// MARK: - Output Protocol
@MainActor
protocol TransferListViewModelOutput: AnyObject {

    var transfersCount: Int { get }
    var hasFavoriteRow: Bool { get }
    var sortOption: SortOption { get set }
    var textSearch: String { get }

    func refreshTransfers()
    func loadNextPageIfNeeded(currentItem: Transfer?)
    func changedTextSearch(with text: String)

    func toggleFavoriteStatus(for transfer: Transfer)
    func checkIsFavorite(_ transfer: Transfer) -> Bool

    func getTransferItem(at index: Int) -> Transfer?
    func toggleCanEdit()
}

// MARK: - ViewModel Implementation
final class TransferListViewModel: TransferListViewModelProtocol {

    // MARK: - Dependencies
    private let fetchTransfersUseCase: FetchTransfersUseCaseProtocol
    private let favoriteUseCase: FavoriteTransferUseCaseProtocol
    private let coordinator: TransferCoordinator

    // MARK: - Callbacks
    var onUpdate: (() -> Void)?
    var onErrorOccurred: ((String) -> Void)?
    var onLoadingStateChange: ((Bool) -> Void)?

    // MARK: - State
    private(set) var canEdit = false
    private var currentPage = 1
    private var hasReachedEnd = false
    private var isLoading = false { didSet { onLoadingStateChange?(isLoading) } }
    private var debouncer = Debouncer(delay: 0.35)

    // Remote transfers
    private var transfers: [Transfer] = [] {
        didSet { onUpdate?() }
    }

    // Favorites
    private var favorites: [Transfer] = []

    var favoriteCounts: Int { favorites.count }
    
    var sortOption: SortOption = .none {
        didSet { onUpdate?() }
    }

    var textSearch: String = "" {
        didSet { onUpdate?() }
    }

    // MARK: - Init
    init(
        fetchTransfersUseCase: FetchTransfersUseCaseProtocol,
        favoriteUseCase: FavoriteTransferUseCaseProtocol,
        coordinator: TransferCoordinator
    ) {
        self.fetchTransfersUseCase = fetchTransfersUseCase
        self.favoriteUseCase = favoriteUseCase
        self.coordinator = coordinator

        loadFavorites()
    }

    // MARK: - Favorites Loading
    func loadFavorites() {
        Task {
            self.favorites = await favoriteUseCase.fetchFavorites()
            onUpdate?()
        }
    }

    // MARK: - Outputs
    var transfersCount: Int { filteredTransfers.count }

    var hasFavoriteRow: Bool {
        !favorites.isEmpty
    }

    // MARK: - Filtering & Sorting
    private var filteredTransfers: [Transfer] {
        filterAndSort(transfers, searchText: textSearch, sortOption: sortOption)
    }

    // MARK: - Data Loading
    private func fetchTransfers(page: Int) {
        guard !isLoading else { return }
        isLoading = true

        Task {
            do {
                let newTransfers = try await fetchTransfersUseCase.fetchTransfers(page: page)

                if newTransfers.isEmpty {
                    hasReachedEnd = true
                    isLoading = false
                    return
                }

                let merged = mergeTransfers(current: transfers, new: newTransfers)

                transfers = merged
            }
            catch {
                onErrorOccurred?(error.localizedDescription)
                currentPage = max(1, currentPage - 1)
            }

            isLoading = false
        }
    }

    func refreshTransfers() {
        currentPage = 1
        transfers = []
        favorites = []
        hasReachedEnd = false
        canEdit = false
        loadFavorites()
        fetchTransfers(page: currentPage)
    }

    func loadNextPageIfNeeded(currentItem: Transfer?) {
        guard let currentItem else { return }
        guard !isLoading, !hasReachedEnd, textSearch.isEmpty else { return }

        guard let idx = filteredTransfers.firstIndex(where: { $0.id == currentItem.id }) else { return }
        guard idx > filteredTransfers.count - 3 else { return }

        currentPage += 1
        fetchTransfers(page: currentPage)
    }

    func mergeTransfers(current: [Transfer]?, new: [Transfer]) -> [Transfer] {
        guard var current, !current.isEmpty else { return new }
        current.append(contentsOf: new)
        return current
    }
    
    func removeItems(item: Transfer) {
        transfers.removeAll { $0.id == item.id }
    }
    
    // MARK: - Favorites Interaction
    func toggleFavoriteStatus(for transfer: Transfer) {
        Task {
            await favoriteUseCase.toggleFavorite(transfer)
            loadFavorites()
        }
    }

    func checkIsFavorite(_ transfer: Transfer) -> Bool {
        favorites.contains { $0.id == transfer.id }
    }

    func getFavorite(at index: Int) -> Transfer? {
        guard favorites.indices.contains(index) else { return nil }
        return favorites[index]
    }

    func getFavoriteTransfer(at index: Int) -> Transfer? {
        guard let fav = getFavorite(at: index) else { return nil }
        return transfers.first { $0.id == fav.id }
    }

    // MARK: - Transfers List Interaction
    func getTransferItem(at index: Int) -> Transfer? {
        filteredTransfers[safe: index]
    }

    // MARK: - UI Interactions
    func toggleCanEdit() {
        canEdit.toggle()
        onUpdate?()
    }

    func routeToDetails(for transfer: Transfer) {
        canEdit = false
        coordinator.showTransfersDetails(transfer: transfer)
    }

    // MARK: - Search
    func changedTextSearch(with text: String) {
        debouncer.schedule { [weak self] in
            Task { @MainActor in
                self?.textSearch = text
            }
        }
    }

    // MARK: - Filtering / Sorting
    private func filterAndSort(_ transfers: [Transfer], searchText: String, sortOption: SortOption) -> [Transfer] {

        let searched = searchText.isEmpty
            ? transfers
            : transfers.filter { $0.name.localizedCaseInsensitiveContains(searchText) }

        return sortTransfers(searched, by: sortOption)
    }

    private func sortTransfers(_ transfers: [Transfer], by option: SortOption) -> [Transfer] {
        switch option {
        case .nameAscending:
            return transfers.sorted { $0.name < $1.name }
        case .nameDescending:
            return transfers.sorted { $0.name > $1.name }
        case .amountAscending:
            return transfers.sorted { $0.amount < $1.amount }
        case .amountDescending:
            return transfers.sorted { $0.amount > $1.amount }
        case .none:
            return transfers
        }
    }
}
