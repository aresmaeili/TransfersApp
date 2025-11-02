//
//  TransferDetailsViewModel.swift
//  TransferFeature
//
//  Created by AREM on 10/31/25.
//

import Foundation

// MARK: - Output Protocol
protocol TransferDetailsViewModelProtocol: TransferDetailsViewModelInput, AnyObject {
    var navigationTitle: String { get }
    var cardViewData: Transfer { get }
    var detailItems: [TransferDetailsItemProtocol] { get }
    var noteItem: TransferDetailsItemProtocol { get }
    var isFavorite: Bool { get }
}

// MARK: - Input Protocol
protocol TransferDetailsViewModelInput: AnyObject {
    var isFavorite: Bool { get }
    func toggleFavorite()
}

// MARK: - Model
struct TransferDetailsItem: TransferDetailsItemProtocol {
    let icon: String
    let title: String
    let value: String
}

// MARK: - ViewModel
final class TransferDetailsViewModel: TransferDetailsViewModelProtocol {

    // MARK: - Dependencies
    private let favoriteUseCase: FavoriteTransferUseCaseProtocol
    
    // MARK: - Stored Properties
    private(set) var cardViewData: Transfer
    
    // MARK: - Initialization
    init(transfer: Transfer, favoriteUseCase: FavoriteTransferUseCaseProtocol) {
        self.cardViewData = transfer
        self.favoriteUseCase = favoriteUseCase
    }
    
    // MARK: - Outputs
    var navigationTitle: String { "\(cardViewData.name) Details" }
    
    var isFavorite: Bool {
        favoriteUseCase.isFavorite(transfer: cardViewData)
    }
    
    var detailItems: [TransferDetailsItemProtocol] {
        [
            TransferDetailsItem(icon: "creditcard", title: "Card Number:", value: cardViewData.cardNumberString),
            TransferDetailsItem(icon: "calendar", title: "Last Transfer Date:", value: cardViewData.lastTransferDate),
            TransferDetailsItem(icon: "dollarsign", title: "Total Transfers:", value: cardViewData.totalAmount),
            TransferDetailsItem(icon: "number", title: "Number of Transfers:", value: cardViewData.countOfTransfer)
        ]
    }
    
    var noteItem: TransferDetailsItemProtocol {
        TransferDetailsItem(icon: "text.bubble", title: "Note:", value: cardViewData.note ?? "")
    }
    
    // MARK: - Inputs
    func toggleFavorite() {
        favoriteUseCase.toggleFavoriteStatus(transfer: cardViewData)
    }
}
