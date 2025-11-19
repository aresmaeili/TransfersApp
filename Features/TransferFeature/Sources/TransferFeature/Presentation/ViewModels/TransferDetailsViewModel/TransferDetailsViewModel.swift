//
//  TransferDetailsViewModel.swift
//  TransferFeature
//
//  Created by AREM on 10/31/25.
//

import Foundation
import Combine

// MARK: - ViewModel Protocols
@MainActor
protocol TransferDetailsViewModelProtocol: TransferDetailsViewModelInput, AnyObject {
    var navigationTitle: String { get }
    var transferData: Transfer { get }
    var detailItems: [TransferDetailsItemProtocol] { get }
    var noteItem: TransferDetailsItemProtocol { get }
}

@MainActor
protocol TransferDetailsViewModelInput: AnyObject {
    var isFavorite: Bool { get }
    var onUpdatePublisher: PassthroughSubject<Void, Never> { get }
    var transferData: Transfer { get }
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
    
    private(set) var transferData: Transfer
    private(set) var isFavorite: Bool = false
    
    // MARK: - Callbacks
    let onUpdatePublisher = PassthroughSubject<Void, Never>()

    // MARK: - Initialization
    
    init(transfer: Transfer, favoriteUseCase: FavoriteTransferUseCaseProtocol) {
        self.transferData = transfer
        self.favoriteUseCase = favoriteUseCase
        loadFavoriteStatus()
    }
    
    // MARK: - Outputs
    
    var navigationTitle: String {
        "\(transferData.name) Details"
    }
    
    var detailItems: [TransferDetailsItemProtocol] {
        [
            TransferDetailsItem(icon: "creditcard", title: "Card Number:", value: transferData.cardNumberString),
            TransferDetailsItem(icon: "calendar", title: "Last Transfer Date:", value: transferData.lastTransferDate),
            TransferDetailsItem(icon: "dollarsign", title: "Total Transfers:", value: transferData.totalAmount),
            TransferDetailsItem(icon: "number", title: "Number of Transfers:", value: transferData.countOfTransfer)
        ]
    }
    
    var noteItem: TransferDetailsItemProtocol {
        TransferDetailsItem(
            icon: "text.bubble",
            title: "Note:",
            value: transferData.note ?? ""
        )
    }
    
    // MARK: - Methods
    
    private func loadFavoriteStatus() {
        Task { [weak self] in
            guard let self else { return }
            
            let isFavorite = await favoriteUseCase.isFavorite(self.transferData)
            if self.isFavorite != isFavorite {
                self.isFavorite = isFavorite
                self.onUpdatePublisher.send()
            }
        }
    }
    
    func toggleFavorite() {
        Task { @MainActor [weak self] in
            guard let self else { return }

            await favoriteUseCase.toggleFavorite(transferData)
            loadFavoriteStatus()
        }
    }
}
