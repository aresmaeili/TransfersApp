//
//  TransferDetailsViewData.swift
//  TransferFeature
//
//  Created by AREM on 11/1/25.
//

struct TransferDetailsItem: TransferDetailsItemProtocol {
    var icon: String
    var title: String
    var value: String
}

extension Transfer: TransferDetailsViewModelProtocol {
    var title: String {
        "\(name) Details"
    }
}

extension Transfer: TransferDetailsCardProtocol {
    var cardTypeString: String {
        card?.cardType ?? "-"
    }
    
    var cardNumberString: String {
        card?.cardNumber ?? "-"
    }
    
    var maskedCardNumber: String {
        /// Returns the card number Masked(e.g., **** 1234).
        guard let number = card?.cardNumber?.trimmingCharacters(in: .whitespacesAndNewlines), number.count >= 4 else { return "-"}
        return "**** " + number.suffix(4)
    }
    
    var lastTransferDate: String {
        lastTransfer?.toDateShowable() ?? "-"
    }
    
    var totalAmount: String {
        moreInfo?.totalTransfer?.asMoneyString() ?? "-"
    }
    
    var countOfTransfer: String {
        moreInfo?.numberOfTransfers?.asSeperatedString() ?? "-"
    }
    
    var isFavorite: Bool {
        return false
    }
}

extension Transfer: TransferDetailsProfileProtocol {
    var avatarUser: String {
        person?.avatar ?? "-"
    }
    
    var mail: String {
        person?.email ?? ""
    }
}

extension Transfer: TransferDetailsItemsProtocol {
    var items: [any TransferDetailsItemProtocol] {
        let items: [TransferDetailsItemProtocol] = [
            TransferDetailsItem(icon: "", title: "Card Numer:", value: cardNo),
            TransferDetailsItem(icon: "", title: "Last Trasnfer Date:", value: lastTransferDate),
            TransferDetailsItem(icon: "", title: "Total Transfers:", value: totalAmount),
            TransferDetailsItem(icon: "", title: "Nmber of Transfers:", value: countOfTransfer),
            TransferDetailsItem(icon: "", title: "Note:", value: note ?? "")
            ]
        return items
    }
}
