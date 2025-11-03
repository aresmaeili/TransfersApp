//
//  TransferListViewModel.swift
//  TransferFeature
//
//  Created by AREM on 10/30/25.
//

import Foundation

// MARK: - Input Protocol
@MainActor
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
    func changedTextSearch(with text: String) {
        textSearch = text
    }
    
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
    
    private var transfers: [Transfer] = [] {
        didSet { onUpdate?() }
    }
    
    // MARK: - Input Properties
    var textSearch: String = "" {
        didSet { onUpdate?() }
    }
    
    var sortOption: SortOption = .none {
        didSet { onUpdate?() }
    }
    
    // MARK: - Computed Properties
    
    var favoriteCount: Int {
        favoriteUseCase.favoritesCount
    }
    
    var transfersCount: Int { filteredTransfers.count }
    
    var hasFavoriteRow: Bool {
        let hasFavorite: Bool = favoriteUseCase.isFavoriteExist
        if !hasFavorite {
            canEdit = false
        }
        return hasFavorite
    }
    
    var filteredTransfers: [Transfer] {
        fetchTransfersUseCase.filterAndSort(transfers, searchText: textSearch, sortOption: sortOption)
    }
    
    var filteredTransfersCount: Int { filteredTransfers.count }
    
    // MARK: - Data Fetching
    private func fetchTransfers(page: Int) {
        guard !isLoading else { return }
        
        Task { [weak self] in
            guard let self else { return }
            
            isLoading = true
            defer {
                isLoading = false
            }
            do {
                let newTransfers = try await fetchTransfersUseCase.fetchTransfers(page: page)
                let totalTransfer = fetchTransfersUseCase.mergeTransfers(current: transfers, new: newTransfers)
                self.transfers = totalTransfer
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
    
    func getTransferItem(at index: Int) -> Transfer? {
        filteredTransfers[safe: index]
    }
    func getFavorite(at index: Int) -> Transfer? { favoriteUseCase.getFavoriteItem(at: index) }
    
    func getFavoriteTransfer(at index: Int) -> Transfer? {
        guard let favorite = favoriteUseCase.getFavoriteItem(at: index),
              let transfer = transfers.first(where: { $0 == favorite }) else {
            onErrorOccurred?("Transfer not found in list.")
            return nil
        }
        return transfer
    }
    
    func getFavorites() -> [Transfer] { favoriteUseCase.fetchFavorites().reversed() }
    
    func checkIsFavorite(_ transfer: Transfer) -> Bool {
        favoriteUseCase.isFavorite(transfer: transfer)
    }
    
    func loadNextPageIfNeeded(currentItem: Transfer?) {
        guard let currentItem, !isLoading, !hasReachedEnd else { return }
        guard let currentIndex = filteredTransfers.firstIndex(where: { $0.id == currentItem.id }) else { return }
        
        let thresholdIndex = filteredTransfers.index(filteredTransfers.endIndex, offsetBy: -2)
        if currentIndex >= thresholdIndex {
            fetchTransfers(page: currentPage + 1)
        }
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
        canEdit = false
        router.showTransfersDetails(transfer: transfer)
    }
    
    func toggleCanEdit() {
        canEdit.toggle()
    }
    
    // MARK: - Private Helpers
    func appendUniqueTransfers(current: [Transfer], new: [Transfer]) -> [Transfer] {
        let existingIDs = Set(current.map(\.id))
        let uniqueNew = new.filter { !existingIDs.contains($0.id) }
        return current + uniqueNew
    }
}
