//
//  TransferDetailsViewData.swift
//  TransferFeature
//
//  Created by AREM on 11/1/25.
//

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
        return "**** **** **** " + number.suffix(4)
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
        return "email: \(person?.email ?? "-")"
    }
}
