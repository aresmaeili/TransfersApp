//
//  TransferListViewModel.swift
//  TransferFeature
//
//  Created by AREM on 10/30/25.
//
import Foundation

// MARK: - TransferListViewModel
@MainActor
final class TransferListViewModel {
    
    // MARK: - Output Bindings (Closures for View)
    var onUpdate: (() -> Void)?
    var onErrorOccurred: ((String) -> Void)?
    var onLoadingStateChange: ((Bool) -> Void)?
    
    // MARK: - Dependencies (Use Cases Injected)
    private let transfersUseCase: FetchTransfersUseCase
    private let favoriteUseCase: FavoriteTransferUseCase
    private let router: TransferCoordinator

    // MARK: - State Properties
    private var currentPage = 1
    private var pagesEnded: Bool = false
    
    private(set) var isLoading: Bool = false {
        didSet {
            onLoadingStateChange?(isLoading)
        }
    }
    
    private var favorites: [Transfer] {
        return favoriteUseCase.getFavorites()
    }
    
    var favoritesCount: Int {
        return favorites.count
    }
    
    private(set) var transfers: [Transfer] = [] {
        didSet {
            onUpdate?()
        }
    }
    
    // MARK: - Input Properties
    
    var textSearch: String = "" {
        didSet {
            onUpdate?()
        }
    }
    
    var sortOption: SortOption = .serverSort {
        didSet {
            onUpdate?()
        }
    }
    
    // MARK: - Computed Properties (View Read-Only Data)
    
    var hasFavoriteRow: Bool {
        return !favorites.isEmpty
    }
    
    var filteredTransfers: [Transfer] {
        var result = transfers
        
        // 1. Search
        if !textSearch.isEmpty {
            result = result.filter { $0.name.localizedCaseInsensitiveContains(textSearch) }
        }
        
        // 2. Sort
        return sortTransfers(result, by: sortOption)
    }
    
    // MARK: - Initialization
    init(transfersUseCase: FetchTransfersUseCase, favoriteUseCase: FavoriteTransferUseCase, router: TransferCoordinator) {
        self.transfersUseCase = transfersUseCase
        self.favoriteUseCase = favoriteUseCase
        self.router = router
    }
    
    // MARK: - Public Interface
    
    private func loadTransfers(page: Int) {
        
        Task { @MainActor in
            guard !isLoading else {
                return
            }
            isLoading = true
        defer {
            isLoading = false
            }
            do {
                let newTransfers = try await transfersUseCase.execute(page: page)
                
                guard !newTransfers.isEmpty else {
                    pagesEnded = true
                    print("End of data")
                    isLoading = false
                    return
                }
                
                if page == 1 {
                    // Refresh / Initial load
                    transfers = newTransfers
                } else {
                    // Pagination
                    let existingIDs = Set(transfers.map { $0.id })
                    let uniqueNew = newTransfers.filter { !existingIDs.contains($0.id) }
                    transfers.append(contentsOf: uniqueNew)
                }
                
                currentPage = page
                print("Page: \(page) -> \(transfers.count) transfers loaded")
                
            } catch {
                onErrorOccurred?(error.localizedDescription)
            }
        }
    }
    
    func editTransfersToFavorite(transfer: Transfer) {
        favoriteUseCase.execute(transfer: transfer)
        onUpdate?()
    }
    
    func getTransfer(at index: Int) -> Transfer? {
        return filteredTransfers[safe: index]
    }
    
    func getFavorite(index : Int) -> Transfer? {
        return favorites[safe: index]
    }
    
    func getFavoriteTransfer(index : Int) -> Transfer? {
        let favorit = favorites[safe: index]
        guard let favoriteTransfer = (transfers.first { transfer in
            transfer == favorit
        }) else {
            onErrorOccurred?("User/Transfer not found in transfers list!")
            return nil
        }
        return favoriteTransfer
    }
    
    func getFavorites() -> [Transfer] {
        return favorites.reversed()
    }
    
    func checkIfTransferIsFavorite(transfer: Transfer) -> Bool {
        return favorites.contains(where: { $0.id == transfer.id })
    }
    
    func loadNextPageIfNeeded(currentItem: Transfer?) {
        guard !isLoading, let currentItem, !pagesEnded else { return }
        
        guard let currentIndex = filteredTransfers.firstIndex(where: { $0.id == currentItem.id }) else { return }
        let thresholdIndex = filteredTransfers.index(filteredTransfers.endIndex, offsetBy: -2)
        
        if currentIndex >= thresholdIndex {
            loadTransfers(page: currentPage + 1)
        }
    }
    
    func refreshTransfers() {
        // Reset state
        currentPage = 1
        transfers = []
        pagesEnded = false
        // Start fetch
        loadTransfers(page: currentPage)
    }
    
    func numberOfRows(section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            return filteredTransfers.count
        default:
            return 0
        }
    }
    
    func routToDetails(for transfer: Transfer) {
        router.showTransfersDetails(transfer: transfer)
    }
    
    // MARK: - Private Helpers
    
    func sortTransfers(_ filteredTransfers: [Transfer], by option: SortOption) -> [Transfer] {
        switch option {
        case .nameAscending:
            return filteredTransfers.sorted { $0.name.localizedCaseInsensitiveCompare($1.name) == .orderedAscending }
        case .nameDescending:
            return filteredTransfers.sorted { $0.name.localizedCaseInsensitiveCompare($1.name) == .orderedDescending }
        case .dateAscending:
            return filteredTransfers.sorted { $0.date < $1.date }
        case .dateDescending:
            return filteredTransfers.sorted { $0.date > $1.date }
        case .amountAscending:
            return filteredTransfers.sorted { $0.amount < $1.amount }
        case .amountDescending:
            return filteredTransfers.sorted { $0.amount > $1.amount }
        case .serverSort:
            return filteredTransfers
        }
    }
}
