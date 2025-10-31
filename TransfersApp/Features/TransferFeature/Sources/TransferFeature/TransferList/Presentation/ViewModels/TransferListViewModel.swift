//
//  TransferListViewModel.swift
//  TransferFeature
//
//  Created by AREM on 10/30/25.
//
import Foundation

// MARK: - TransferListDelegate
@MainActor
protocol TransferListDisplay: AnyObject {
    func didUpdateTransfers()
    func displayError(_ message: String)
}

// MARK: - TransferListViewModel
@MainActor
final class TransferListViewModel {
    // MARK: - Dependencies (Use Cases Injected)
    private let transfersUseCase: FetchTransfersUseCase
    private let favoriteUseCase: FavoriteTransferUseCase
    
    // MARK: - Properties
    weak var delegate: TransferListDisplay?

    private var currentPage = 1

//    @UserDefaultTransfers var favoritesTranfers: [Transfer]
    private var favorites: [Transfer] {
        return favoriteUseCase.getFavorites()
    }
    
    var textSearch: String = "" {
        didSet {
            delegate?.didUpdateTransfers()
        }
    }

    var sortOption: SortOption = .nameAscending {
        didSet {
            delegate?.didUpdateTransfers()
        }
    }
    
    private(set) var isGettingData = false
    private(set) var transfers: [Transfer] = [] {
        didSet {
            delegate?.didUpdateTransfers()
        }
    }

    var filteredTransfers: [Transfer] {
        var result = transfers
        // 1. Search
        if !textSearch.isEmpty {
            result = result.filter { $0.name.contains(textSearch) }
        }
        // 2. Sort
        return sortTransfers(result, by: sortOption).reversed()
    }
    
    // MARK: - Initialization
    init(transfersUseCase: FetchTransfersUseCase, favoriteUseCase: FavoriteTransferUseCase, delegate: TransferListDisplay?) {
        self.transfersUseCase = transfersUseCase
        self.favoriteUseCase = favoriteUseCase
        self.delegate = delegate
    }
    
    // MARK: - Public Interface
    private func loadTransfers(page: Int) {
//        TODO: check this
        Task { @MainActor in
            guard !isGettingData else { return }
            isGettingData = true
            defer { isGettingData = false }
            do {
                transfers = try await transfersUseCase.execute(page: currentPage)
                currentPage += 1
            } catch {
                delegate?.displayError(error.localizedDescription)
            }
        }
    }
    
    func addTransfersToFavorite(transfer: Transfer) {
        favoriteUseCase.execute(transfer: transfer, shouldBeFavorite: true)
    }
    
    func getTransfer(at index: Int) -> Transfer? {
        return filteredTransfers[safe: index]
    }
    
    func getFavorites() -> [Transfer]? {
        return favorites.reversed()
    }
    
    func loadNextPageIfNeeded(currentItem: Transfer?) {
        Task {
            refreshTransfers()
            
            let thresholdIndex = filteredTransfers.index(filteredTransfers.endIndex, offsetBy: -2)
            if filteredTransfers.firstIndex(where: { $0.id == currentItem?.id }) == thresholdIndex {
                loadTransfers(page: currentPage)
            }
        }
     }
    
    func refreshTransfers() {
        // 1. Reset state
        currentPage = 1
        transfers = []
        // 2. Start fetch
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
        }
    }
}
