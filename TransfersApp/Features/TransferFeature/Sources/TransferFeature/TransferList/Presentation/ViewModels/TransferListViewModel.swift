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
    
    private(set) var transfers: [Transfer] = [] {
        didSet {
            delegate?.didGetTransfers()
        }
    }
    
    var filteredTransfers: [Transfer]?  {
        didSet {
            delegate?.didGetTransfers()
        }
    }
    
    init(transfersUseCase: FetchTransfersUseCase, delegate: TransferListDelegate?) {
        self.transfersUseCase = transfersUseCase
        self.delegate = delegate
    }
    
    
    func loadTransfers() {
        Task {
            do {
                transfers = try await transfersUseCase.execute()
                filteredTransfers = transfers
            } catch {
                delegate?.getTransfersError(error.localizedDescription)
            }
        }
    }
    
    func search(_ text: String) {
        
        guard !text.isEmpty else {
            if filteredTransfers != transfers {
                filteredTransfers = transfers
            }
            return
        }
        filteredTransfers = transfers.filter {
            $0.name.hasPrefix(text)
        }
    }
}

@MainActor
protocol TransferListDelegate: AnyObject {
    func didGetTransfers()
    func getTransfersError(_ message: String)
}
