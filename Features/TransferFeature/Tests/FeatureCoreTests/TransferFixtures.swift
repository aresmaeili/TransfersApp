//
//  TransferFixtures.swift
//  TransferFeature
//
//  Created by AREM on 11/10/25.
//


import Foundation
@testable import TransferFeature

public enum TransferFixtures {
    public static func person(
        fullName: String = "Alice Johnson",
        email: String = "alice@example.com",
        avatar: String = "https://example.com/a.jpg"
    ) -> Person { .init(fullName: fullName, email: email, avatar: avatar) }

    public static func card(
        number: String = "6232 4235 5642 4321",
        type: String = "Visa"
    ) -> Card { .init(cardNumber: number, cardType: type) }

    public static func moreInfo(
        count: Int = 3,
        total: Int = 1200
    ) -> MoreInfo { .init(numberOfTransfers: count, totalTransfer: total) }

    public static func transfer(
        fullName: String = "Alice Johnson",
        email: String = "alice@example.com",
        cardNumber: String = "6232 4235 5642 4321",
        total: Int = 1200,
        last: String = "2024-01-10T09:15:00Z",
        note: String = "Monthly rent"
    ) -> Transfer {
        .init(
            person: person(fullName: fullName, email: email),
            card: card(number: cardNumber),
            lastTransfer: last,
            note: note,
            moreInfo: moreInfo(total: total)
        )
    }
}