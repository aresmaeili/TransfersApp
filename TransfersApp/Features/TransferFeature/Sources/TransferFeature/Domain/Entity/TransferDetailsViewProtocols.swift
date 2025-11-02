//
//  TransferDetailsViewData.swift
//  TransferFeature
//
//  Created by AREM on 11/1/25.
//

import Foundation

// MARK: - Transfer + TransferDataShowable

extension Transfer: TransferCellShowable {
    
    public var id: String {
        name + cardNumberString
    }
    
    var cardNumberString: String {
        card?.cardNumber ?? "-"
    }
    
    var avatarURLString: String? {
        person?.avatar
    }
    
    var avatar: String? {
        person?.avatar
    }
    
    var name: String {
        person?.fullName ?? "-"
    }
    
    var date: Date {
        lastTransfer?.toISODate() ?? Date(timeIntervalSince1970: 0)
    }
    
    var dateString: String {
        lastTransfer?.toISODate()?.toDateString(dateStyle: .medium, timeStyle: .none) ?? ""
    }
    
    var amount: Int {
        moreInfo?.totalTransfer ?? 0
    }
    
    var amountString: String {
        moreInfo?.totalTransfer?.asMoneyString() ?? ""
    }
}

// MARK: - Transfer + TransferDetailsCardProtocol

extension Transfer: TransferDetailsCardProtocol {
    
    var cardTypeString: String {
        card?.cardType ?? "-"
    }
    
    var maskedCardNumber: String {
        /// Returns the masked card number (e.g. "**** **** **** 1234").
        guard let number = card?.cardNumber?.trimmingCharacters(in: .whitespacesAndNewlines),
              number.count >= 4 else {
            return "-"
        }
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
        false
    }
}

// MARK: - Transfer + TransferDetailsProfileProtocol

extension Transfer: TransferDetailsProfileProtocol {
    
    var avatarUser: String {
        person?.avatar ?? "-"
    }
    
    var mail: String {
        "📧\(person?.email ?? "-")"
    }
}
