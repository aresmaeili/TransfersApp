//
//  TransferDetailsViewModelProtocol.swift
//  TransferFeature
//
//  Created by AREM on 10/31/25.
//
import Foundation

protocol TransferDetailsViewModelProtocol: TransferDetailsCardProtocol, TransferDetailsProfileProtocol {
    var title: String { get }
}

final class TransferDetailsViewModel {
    private let transfer: TransferDetailsViewModelProtocol

    // Initializer receives the data directly
    init(transfer: TransferDetailsViewModelProtocol) {
        self.transfer = transfer
    }
    
}


struct TransferDetailsItem: TransferDetailsItemProtocol {
    var icon: String
    var title: String
    var value: String
}

extension TransferDetailsViewModel: TransferDetailsItemsProtocol {
    var items: [any TransferDetailsItemProtocol] {
        let items: [TransferDetailsItemProtocol] = [
            TransferDetailsItem(icon: "", title: "Card Numer:", value: transfer.cardNumberString),
            TransferDetailsItem(icon: "", title: "Last Trasnfer Date:", value: transfer.lastTransferDate),
            TransferDetailsItem(icon: "", title: "Total Transfers:", value: transfer.totalAmount),
            TransferDetailsItem(icon: "", title: "Nmber of Transfers:", value: transfer.countOfTransfer),
            TransferDetailsItem(icon: "", title: "Note:", value: transfer.note ?? "")
            ]
        return items
    }
}
