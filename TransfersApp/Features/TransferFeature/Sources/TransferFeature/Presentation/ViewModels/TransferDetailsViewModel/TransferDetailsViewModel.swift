//
//  TransferDetailsViewModel.swift
//  TransferFeature
//
//  Created by AREM on 10/31/25.
//

import Foundation

// MARK: - ViewModel Protocols

/// Defines the outputs and exposed data of the Transfer Details ViewModel.
protocol TransferDetailsViewModelProtocol: TransferDetailsViewModelInput, AnyObject {
    var navigationTitle: String { get }
    var cardViewData: Transfer { get }
    var detailItems: [TransferDetailsItemProtocol] { get }
    var noteItem: TransferDetailsItemProtocol { get }
    var isFavorite: Bool { get }
}

/// Defines the input actions that can be triggered from the view.
protocol TransferDetailsViewModelInput: AnyObject {
    var isFavorite: Bool { get }
    func toggleFavorite()
}

// MARK: - TransferDetailsItem

/// Represents a single labeled item displayed in the transfer details view.
struct TransferDetailsItem: TransferDetailsItemProtocol {
    let icon: String
    let title: String
    let value: String
}

// MARK: - TransferDetailsViewModel

/// ViewModel responsible for providing formatted data for the transfer details screen.
final class TransferDetailsViewModel: TransferDetailsViewModelProtocol {
    
    // MARK: - Dependencies
    
    private let favoriteUseCase: FavoriteTransferUseCaseProtocol
    
    // MARK: - State
    
    private(set) var cardViewData: Transfer
    
    // MARK: - Initialization
    
    init(transfer: Transfer, favoriteUseCase: FavoriteTransferUseCaseProtocol) {
        self.cardViewData = transfer
        self.favoriteUseCase = favoriteUseCase
    }
    
    // MARK: - Outputs
    
    var navigationTitle: String {
        "\(cardViewData.name) Details"
    }
    
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
        TransferDetailsItem(
            icon: "text.bubble",
            title: "Note:",
            value: cardViewData.note ?? ""
        )
    }
    
    // MARK: - Inputs
    
    func toggleFavorite() {
        favoriteUseCase.toggleFavoriteStatus(transfer: cardViewData)
    }
}
