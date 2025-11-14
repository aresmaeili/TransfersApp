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
    var canEdit: Bool { get }
    var favoriteCount: Int { get }
    
    func getFavoriteTransfer(at index: Int) -> Transfer?
    func getFavorite(at index: Int) -> Transfer?
    func toggleFavoriteStatus(for transfer: Transfer)
    func routeToDetails(for transfer: Transfer)
    func removeItems(item: Transfer)
}

// MARK: - Output Protocol
@MainActor
protocol TransferListViewModelOutput: AnyObject {
    func checkIsFavorite(_ transfer: Transfer) -> Bool
    var hasFavoriteRow: Bool { get }
    var transfersCount: Int { get }
    var sortOption: SortOption { get set }
    var canEdit: Bool { get }
    var textSearch: String { get }
    var onUpdate: (() -> Void)? { get set }
    var onErrorOccurred: ((String) -> Void)? { get set }
    var onLoadingStateChange: ((Bool) -> Void)? { get set }
    
    func getFavorites() -> [Transfer]
    func loadNextPageIfNeeded(currentItem: Transfer?)
    func changedTextSearch(with text: String)
    func toggleCanEdit()
    func refreshTransfers()
    func routeToDetails(for transfer: Transfer)
    func getTransferItem(at index: Int) -> Transfer?
    func getFavorite(at index: Int) -> Transfer?
}

// MARK: - ViewModel Implementation
@MainActor
final class TransferListViewModel: TransferListViewModelProtocol {

    // MARK: - Dependencies
    private let fetchTransfersUseCase: FetchTransfersUseCaseProtocol
    private let favoriteUseCase: FavoriteTransferUseCaseProtocol
    private let coordinator: TransferCoordinator
    
    // MARK: - Outputs
    var onUpdate: (() -> Void)?
    var onErrorOccurred: ((String) -> Void)?
    var onLoadingStateChange: ((Bool) -> Void)?

    // MARK: - State
    private(set) var canEdit = false
    private var currentPage = 1
    private var isLoading = false { didSet { onLoadingStateChange?(isLoading) }}
    private var hasReachedEnd = false
    private var debouncer = Debouncer(delay: 0.35)

    private var transfers: [Transfer] = [] {
        didSet { onUpdate?() }
    }
    
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
    }

    // MARK: - Outputs
    var favoriteCount: Int { favoriteUseCase.favoritesCount }

    var hasFavoriteRow: Bool {
        let hasFavorite: Bool = favoriteUseCase.isFavoriteExist
        if !hasFavorite { canEdit = false }
        return hasFavorite
    }

    var transfersCount: Int {
        filteredTransfers.count
    }
    
    // MARK: - Filtering & Sorting
    private var filteredTransfers: [Transfer] {
        filterAndSort(transfers, searchText: textSearch, sortOption: sortOption)
    }

    // MARK: - Data Loading
    private func fetchTransfers(page: Int) {
        guard !isLoading else { return }
        isLoading = true

        Task.detached { [weak self] in
            guard let self else { return }

            do {
                let newTransfers = try await self.fetchTransfersUseCase.fetchTransfers(page: page)

                guard !newTransfers.isEmpty else {
                    await MainActor.run { self.hasReachedEnd = true; self.isLoading = false }
                    return
                }

                let merged = await self.fetchTransfersUseCase.mergeTransfers(current: self.transfers, new: newTransfers)

                await MainActor.run {
                    self.transfers = merged
                    self.isLoading = false
                }
            }
            catch {
                await MainActor.run {
                    self.onErrorOccurred?(error.localizedDescription)
                    self.currentPage = max(1, self.currentPage - 1)
                    self.isLoading = false
                }
            }
        }
    }

    func refreshTransfers() {
        currentPage = 1
        transfers = []
        hasReachedEnd = false
        canEdit = false
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

    // MARK: - Interaction
    func toggleFavoriteStatus(for transfer: Transfer) {
        favoriteUseCase.toggleFavoriteStatus(transfer: transfer)
        onUpdate?()
    }

    func removeItems(item: Transfer) {
        transfers.removeAll { $0.id == item.id }
        onUpdate?()
    }

    func routeToDetails(for transfer: Transfer) {
        canEdit = false
        coordinator.showTransfersDetails(transfer: transfer)
    }

    func toggleCanEdit() {
        canEdit.toggle()
        onUpdate?()
    }

    // MARK: - Helpers
    func getTransferItem(at index: Int) -> Transfer? {
        filteredTransfers[safe: index]
    }

    func getFavorite(at index: Int) -> Transfer? {
        favoriteUseCase.getFavoriteItem(at: index)
    }

    func getFavoriteTransfer(at index: Int) -> Transfer? {
        guard let fav = favoriteUseCase.getFavoriteItem(at: index) else { return nil }
        return transfers.first(where: { $0.id == fav.id })
    }

    func checkIsFavorite(_ transfer: Transfer) -> Bool {
        favoriteUseCase.isFavorite(transfer: transfer)
    }

    func getFavorites() -> [Transfer] {
        favoriteUseCase.fetchFavorites().reversed()
    }

    // MARK: - Search
    func changedTextSearch(with text: String) {
        debouncer.schedule { [weak self] in
            self?.textSearch = text
        }
    }

    // MARK: - Filter & Sort
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
