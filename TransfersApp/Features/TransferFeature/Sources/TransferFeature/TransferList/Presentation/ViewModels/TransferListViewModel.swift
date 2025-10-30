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

    init(transfersUseCase: FetchTransfersUseCase, delegate: TransferListDelegate?) {
        self.transfersUseCase = transfersUseCase
        self.delegate = delegate
    }
    
   
    func loadTransfers() {
        Task {
            do {
                transfers = try await transfersUseCase.execute()
            } catch {
                print(error.localizedDescription)
            }
        }
    }
}

@MainActor
protocol TransferListDelegate: AnyObject {
    func didGetTransfers()
}
