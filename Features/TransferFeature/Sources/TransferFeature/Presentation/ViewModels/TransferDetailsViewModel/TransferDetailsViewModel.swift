//
//  TransferDetailsViewModel.swift
//  TransferFeature
//
//  Created by AREM on 10/31/25.
//

import Foundation

// MARK: - ViewModel Protocols
@MainActor
protocol TransferDetailsViewModelProtocol: TransferDetailsViewModelInput, AnyObject {
    var navigationTitle: String { get }
    var cardViewData: Transfer { get }
    var detailItems: [TransferDetailsItemProtocol] { get }
    var noteItem: TransferDetailsItemProtocol { get }
}

@MainActor
protocol TransferDetailsViewModelInput: AnyObject {
    var isFavorite: Bool { get }
    var onUpdate: (() -> Void)? { get }
    var cardViewData: Transfer { get }
    func toggleFavorite()
}

// MARK: - TransferDetailsItem

struct TransferDetailsItem: TransferDetailsItemProtocol {
    let icon: String
    let title: String
    let value: String
}

// MARK: - TransferDetailsViewModel

final class TransferDetailsViewModel: TransferDetailsViewModelProtocol {
    
    // MARK: - Dependencies
    
    private let favoriteUseCase: FavoriteTransferUseCaseProtocol
    
    // MARK: - State
    
    private(set) var cardViewData: Transfer
    private(set) var isFavorite: Bool = false
    var onUpdate: (() -> Void)?
    var onErrorOccurred: ((String) -> Void)?
    var onLoadingStateChange: ((Bool) -> Void)?

    // MARK: - Initialization
    
    init(transfer: Transfer, favoriteUseCase: FavoriteTransferUseCaseProtocol) {
        self.cardViewData = transfer
        self.favoriteUseCase = favoriteUseCase
        loadFavoriteStatus()
    }
    
    // MARK: - Outputs
    
    var navigationTitle: String {
        "\(cardViewData.name) Details"
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
    
    // MARK: - Methods
    
    func loadFavoriteStatus() {
        Task {
            self.isFavorite = await favoriteUseCase.isFavorite(cardViewData)
            onUpdate?()
        }
    }
    
    func toggleFavorite() {
        Task {
            await favoriteUseCase.toggleFavorite(cardViewData)
            self.isFavorite = await favoriteUseCase.isFavorite(cardViewData)
            onUpdate?()
        }
    }
}
