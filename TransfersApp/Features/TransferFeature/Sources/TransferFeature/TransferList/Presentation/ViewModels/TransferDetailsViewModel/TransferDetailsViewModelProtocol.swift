//
//  TransferDetailsViewModelProtocol.swift
//  TransferFeature
//
//  Created by AREM on 10/31/25.
//


// 1. Define the ViewModel Protocol (for testability)
protocol TransferDetailsViewModelProtocol {
    var title: String { get }
    var amountText: String { get }
    var dateText: String { get }
    // ... other display properties
}

// 2. Implement the ViewModel
final class TransferDetailsViewModel: TransferDetailsViewModelProtocol {
    private let transfer: Transfer // Holds the Domain Entity

    // MARK: - Output Properties
    let title: String
    let amountText: String
    let dateText: String
    
    // Initializer receives the data directly
    init(transfer: Transfer) {
        self.transfer = transfer
        
        // Format the Domain Entity properties for UI display
        self.title = transfer.name
        self.amountText = "Amount: $\(transfer.amount)" // Use a proper formatter in a real app!
        self.dateText = transfer.date.toDateString()
    }
}
