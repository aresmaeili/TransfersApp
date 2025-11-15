//
//  TransferListViewModel.swift
//  TransferFeature
//
//  Created by AREM on 10/30/25.
//

import Foundation
import Shared
import Combine

// MARK: - Input Protocol
@MainActor
protocol FavoritesCellViewModelInput: AnyObject {
    var canEdit: Bool { get }
    var favoriteCounts: Int { get }
    
    func getFavoriteTransfer(at index: Int) -> Transfer?
    func getFavorite(at index: Int) -> Transfer?
    func toggleFavoriteStatus(for transfer: Transfer)
    func routeToDetails(for transfer: Transfer)
}

// MARK: - Output Protocol
@MainActor
protocol TransfersViewModelInputProtocol: FavoritesCellViewModelInput, AnyObject {
    var onUpdatePublisher: PassthroughSubject<Void, Never> { get }
    var onErrorPublisher: PassthroughSubject<String, Never> { get }
    var onLoadingStatePublisher: PassthroughSubject<Bool, Never> { get }
    
    var transfersCount: Int { get }
    var hasFavoriteRow: Bool { get }
    var sortOption: SortOption { get set }
    var textSearch: String { get }
    
    func refreshTransfers()
    func getTransferItem(at index: Int) -> Transfer?
    func loadNextPageIfNeeded(index: Int?)
    func changedTextSearch(with text: String)
    func checkIsFavorite(_ transfer: Transfer) -> Bool
    func loadFavorites()
    func toggleCanEdit()
    func removeItems(item: Transfer)
}

// MARK: - ViewModel Implementation
final class TransferListViewModel: TransfersViewModelInputProtocol {
    
    // MARK: - Dependencies
    private var fetchTransfersUseCase: FetchTransfersUseCaseProtocol
    private let favoriteUseCase: FavoriteTransferUseCaseProtocol
    private let coordinator: TransferCoordinator
    
    // MARK: - Callbacks
    let onUpdatePublisher = PassthroughSubject<Void, Never>()
    let onErrorPublisher = PassthroughSubject<String, Never>()
    let onLoadingStatePublisher = PassthroughSubject<Bool, Never>()
    
    // MARK: - State
    private(set) var canEdit = false
    private var hasReachedEnd: Bool { fetchTransfersUseCase.listEnded }
    private var isLoading = false { didSet { onLoadingStatePublisher.send(isLoading) } }
    private var debouncer = Debouncer(delay: 0.35)
    
    // Remote transfers
    private var transfers: [Transfer] = [] {
        didSet { onUpdatePublisher.send() }
    }
    
    // Favorites
    private var favorites: [Transfer] = []
    
    var favoriteCounts: Int { favorites.count }
    
    var sortOption: SortOption = .none {
        didSet { onUpdatePublisher.send() }
    }
    
    var textSearch: String = "" {
        didSet { onUpdatePublisher.send() }
    }
    
    // MARK: - Init
    init(fetchTransfersUseCase: FetchTransfersUseCaseProtocol, favoriteUseCase: FavoriteTransferUseCaseProtocol, coordinator: TransferCoordinator) {
        self.fetchTransfersUseCase = fetchTransfersUseCase
        self.favoriteUseCase = favoriteUseCase
        self.coordinator = coordinator
        
        loadFavorites()
    }
    
    // MARK: - Favorites Loading
    func loadFavorites() {
        //        TODO: check this @MainActor
        Task { @MainActor [weak self] in
            guard let self else { return }
            self.favorites = await self.favoriteUseCase.fetchFavorites()
            self.onUpdatePublisher.send()
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
    private func fetchTransfers() {
        guard !isLoading else { return }
        isLoading = true
        
        Task { @MainActor [weak self] in
            guard let self else { return }
            do {
                let newTransfers = try await fetchTransfersUseCase.fetchTransfers()
                let merged = mergeTransfers(current: transfers, new: newTransfers)
                transfers = merged
            }
            catch {
                onErrorPublisher.send(error.localizedDescription)
            }
            isLoading = false
        }
    }
    
    func refreshTransfers() {
        transfers = []
        favorites = []
        canEdit = false
        loadFavorites()
        fetchTransfersUseCase.refreshTransfers()
        fetchTransfers()
    }
    
    func loadNextPageIfNeeded(index: Int?) {
        guard let index, !isLoading, !hasReachedEnd, textSearch.isEmpty else { return }
        guard index > filteredTransfers.count - 3 else { return }
        fetchTransfers()
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
        onUpdatePublisher.send()
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
