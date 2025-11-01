//
//  TransferDetailsViewModelProtocol.swift
//  TransferFeature
//
//  Created by AREM on 10/31/25.
//
import Foundation

protocol TransferDetailsViewModelProtocol: TransferDetailsCardProtocol, TransferDetailsProfileProtocol, TransferDetailsItemsProtocol {
    var title: String { get }
}

final class TransferDetailsViewModel {
    private let transfer: TransferDetailsViewModelProtocol

    // Initializer receives the data directly
    init(transfer: TransferDetailsViewModelProtocol) {
        self.transfer = transfer
    }
    
}

