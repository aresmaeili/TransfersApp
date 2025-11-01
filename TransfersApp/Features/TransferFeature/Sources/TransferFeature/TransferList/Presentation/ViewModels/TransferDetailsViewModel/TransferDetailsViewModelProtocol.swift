//
//  TransferDetailsViewModelProtocol.swift
//  TransferFeature
//
//  Created by AREM on 10/31/25.
//
import Foundation

protocol TransferDetailsViewModelProtocol: TransferDetailsCardProtocol, TransferDetailsProfileProtocol {
    var title: String { get }
    var transferNote: String { get }
}

fileprivate struct TransferDetailsItem: TransferDetailsItemProtocol {
    var icon: String
    var title: String
    var value: String
}

final class TransferDetailsViewModel {
    
    let transfer: Transfer
    var isFavorite: Bool {
        favoriteUseCase.checkIsFavorite(transfer: transfer)
    }
    
    private let favoriteUseCase: FavoriteTransferUseCase

    init(transfer: Transfer, favoriteUseCase: FavoriteTransferUseCase) {
        self.transfer = transfer
        self.favoriteUseCase = favoriteUseCase
    }
    
    var items: [any TransferDetailsItemProtocol] {
        let items: [TransferDetailsItemProtocol] = [
            TransferDetailsItem(icon: "creditcard", title: "Card Number:", value: transfer.cardNumberString),
            TransferDetailsItem(icon: "calendar", title: "Last Trasnfer Date:", value: transfer.lastTransferDate),
            TransferDetailsItem(icon: "dollarsign", title: "Total Transfers:", value: transfer.totalAmount),
            TransferDetailsItem(icon: "number", title: "Number of Transfers:", value: transfer.countOfTransfer),
//            TransferDetailsItem(icon: "text.bubble", title: "Note:", value: transfer.note ?? "-")
            ]
        return items
    }
    
    func addTransfersToFavorite(transfer: Transfer, shouldBeFavorite: Bool) {
        favoriteUseCase.execute(transfer: transfer, shouldBeFavorite: shouldBeFavorite)
    }
}
