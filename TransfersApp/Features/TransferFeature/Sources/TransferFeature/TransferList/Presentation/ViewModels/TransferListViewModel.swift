//
//  TransferListViewModel.swift
//  TransferFeature
//
//  Created by AREM on 10/30/25.
//
import Foundation

@MainActor
final class TransferListViewModel {
    
    private let transfersUseCase: FetchTransfersUseCase
    weak var delegate: TransferListDelegate?
    
    @UserDefaultTransfers var favoritesTranfers: [Transfer]
    var textSearch: String = "" {
        didSet {
            filterAndSearch()
        }
    }
    
    var favoritesTranfersReversed: [Transfer] {
        favoritesTranfers.reversed()
    }
    
    var sortOption: SortOption = .nameAscending {
        didSet {
            filterAndSearch()
        }
    }
    
    private(set) var transfers: [Transfer] = [] {
        didSet {
            delegate?.didGetTransfers()
        }
    }
    
    var filteredTransfers: [Transfer] = []  {
        didSet {
            delegate?.didGetTransfers()
        }
    }
    
    var numberOfSections: Int {
        return 2
    }

    init(transfersUseCase: FetchTransfersUseCase, delegate: TransferListDelegate?) {
        self.transfersUseCase = transfersUseCase
        self.delegate = delegate
    }
    
    func sectionCount(section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            return filteredTransfers.count
        default:
            return 0
        }
    }
    
    func getSectionTitle(section: Int) -> String {
        switch section {
        case 0:
            return "Favorites:"
        case 1:
            return "Transfers:"
        default:
            return ""
        }
    }
    
    func loadTransfers() {
        Task {
            do {
                transfers = try await transfersUseCase.execute()
                filteredTransfers = sortTransfers(transfers, by: sortOption)
            } catch {
                delegate?.getTransfersError(error.localizedDescription)
            }
        }
    }
    
    func filterAndSearch() {
        guard !textSearch.isEmpty else {
            if filteredTransfers != transfers {
                filteredTransfers = transfers
                filteredTransfers = sortTransfers(filteredTransfers, by: sortOption)
            }
            return
        }
        filteredTransfers = transfers.filter {
            $0.name.hasPrefix(textSearch)
        }
        filteredTransfers = sortTransfers(filteredTransfers, by: sortOption)
    }
    
    func addTransfersToFavorite(transfer: Transfer) {
        favoritesTranfers.append(transfer)
    }
    
    func sortTransfers(_ filteredTransfers: [Transfer] ,by option: SortOption) -> [Transfer] {
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
    
    func getTransfer(at index: Int) -> Transfer? {
        return filteredTransfers[safe: index]
    }
}

@MainActor
protocol TransferListDelegate: AnyObject {
    func didGetTransfers()
    func getTransfersError(_ message: String)
}

enum SortOption: String {
    case nameAscending = "Name Asc"
    case nameDescending = "Name Desc"
    case dateAscending = "Date Asc"
    case dateDescending = "Date Desc"
    case amountAscending = "Amount Asc"
    case amountDescending = "Amount Desc"
}

@propertyWrapper
struct UserDefaultTransfers {
    private let key = "savedTransfers"
    private let userDefaults = UserDefaults.standard
    
    var wrappedValue: [Transfer] {
        get {
            guard let data = userDefaults.data(forKey: key) else { return [] }
            let transfers: [Transfer] = (try? JSONDecoder().decode([Transfer].self, from: data)) ?? []
            return transfers
        }
        set {
            if let data = try? JSONEncoder().encode(newValue) {
                userDefaults.set(data, forKey: key)
            } else {
                userDefaults.removeObject(forKey: key)
            }
        }
    }
}
