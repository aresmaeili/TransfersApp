//
//  TransferMockData.swift
//  TransferFeature
//
//  Created by AREM on 10/30/25.
//



final class TransferMockData: TransferDataSource {
    func fetchTransfers() async throws -> [Transfer] {
        let transfers: [Transfer] = [
            Transfer(
                person: Person(
                    fullName: "Alice Johnson",
                    email: "alice.johnson@example.com",
                    avatar: "https://example.com/avatars/alice.png"
                ),
                card: Card(
                    cardNumber: "**** **** **** 4321",
                    cardType: "Visa"
                ),
                note: "Monthly rent payment",
                lastTransfer: "2022-08-31T15:24:16Z",
                moreInfo: MoreInfo(
                    numberOfTransfers: 12,
                    totalTransfer: 12000
                )
            ),
            Transfer(
                person: Person(
                    fullName: "Bob Martinez",
                    email: "bob.martinez@example.com",
                    avatar: "https://example.com/avatars/bob.png"
                ),
                card: Card(
                    cardNumber: "**** **** **** 9876",
                    cardType: "MasterCard"
                ),
                note: "Dinner reimbursement",
                lastTransfer: "2022-08-31T15:24:16Z",
                moreInfo: MoreInfo(
                    numberOfTransfers: 5,
                    totalTransfer: 450
                )
            ),
            Transfer(
                person: Person(
                    fullName: "Clara Lee",
                    email: "clara.lee@example.com",
                    avatar: "https://example.com/avatars/clara.png"
                ),
                card: Card(
                    cardNumber: "**** **** **** 1122",
                    cardType: "Amex"
                ), note: "Project expense split",
                lastTransfer: "2022-08-31T15:24:16Z",
                moreInfo: MoreInfo(
                    numberOfTransfers: 8,
                    totalTransfer: 2200
                )
            ),
            Transfer(
                person: Person(
                    fullName: "David Chen",
                    email: "david.chen@example.com",
                    avatar: "https://example.com/avatars/david.png"
                ),
                card: Card(
                    cardNumber: "**** **** **** 3344",
                    cardType: "Discover"
                ),
                note: "Gift transfer",
                lastTransfer: "2022-08-31T15:24:16Z",
                moreInfo: MoreInfo(
                    numberOfTransfers: 3,
                    totalTransfer: 300
                )
            )
        ]
        
        return transfers
    }
}
