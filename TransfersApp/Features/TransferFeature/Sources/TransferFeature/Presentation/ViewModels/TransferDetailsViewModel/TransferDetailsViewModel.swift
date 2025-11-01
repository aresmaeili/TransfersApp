//
//  TransferDetailsViewModelProtocol.swift
//  TransferFeature
//
//  Created by AREM on 10/31/25.
//
import Foundation

fileprivate struct TransferDetailsItem: TransferDetailsItemProtocol {
    var icon: String
    var title: String
    var value: String
}

final class TransferDetailsViewModel {
    
    let cardViewData: Transfer
    var navigationTitle: String { return "\(cardViewData.name) Details" }
    
    var isFavorite: Bool {
        get {
            favoriteUseCase.checkIsFavorite(transfer: cardViewData)
        } set {
            favoriteUseCase.execute(transfer: cardViewData)
        }
    }
    
    private let favoriteUseCase: FavoriteTransferUseCase

    init(transfer: Transfer, favoriteUseCase: FavoriteTransferUseCase) {
        self.cardViewData = transfer
        self.favoriteUseCase = favoriteUseCase
    }
    
    var items: [any TransferDetailsItemProtocol] {
        let items: [TransferDetailsItemProtocol] = [
            TransferDetailsItem(icon: "creditcard", title: "Card Number:", value: cardViewData.cardNumberString),
            TransferDetailsItem(icon: "calendar", title: "Last Trasnfer Date:", value: cardViewData.lastTransferDate),
            TransferDetailsItem(icon: "dollarsign", title: "Total Transfers:", value: cardViewData.totalAmount),
            TransferDetailsItem(icon: "number", title: "Number of Transfers:", value: cardViewData.countOfTransfer),
//            TransferDetailsItem(icon: "text.bubble", title: "Note:", value: transfer.note ?? "-")
            ]
        return items
    }

    func toggleFavorite() {
        favoriteUseCase.execute(transfer: cardViewData)

    }
}
