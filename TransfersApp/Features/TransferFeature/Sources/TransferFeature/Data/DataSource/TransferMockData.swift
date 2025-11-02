//
//  TransferMockData.swift
//  TransferFeature
//
//  Created by AREM on 10/30/25.
//

final class TransferMockData: TransferDataSource {
    func fetchTransfers(page: Int) async throws -> [Transfer] {
        var  transfers: [Transfer] {
            [
                Transfer(
                    person: Person(
                        fullName: "Alice \(page) Johnson",
                        email: "alice.johnson@example.com",
                        avatar: "https://images.squarespace-cdn.com/content/v1/590beb9b893fc0ef1a3523e3/1658676534970-2Q1WYKZGJ571C2N50WWY/Sammy-19.jpg?format=1500w"
                    ),
                    card: Card(
                        cardNumber: "**** **** **** 4321",
                        cardType: "Visa"
                    ),
                    lastTransfer: "2022-08-31T15:24:16Z",
                    note: "Monthly rent payment",
                    moreInfo: MoreInfo(
                        numberOfTransfers: 12,
                        totalTransfer: 12000
                    )
                ),
                Transfer(
                    person: Person(
                        fullName: "Bob \(page) Martinez",
                        email: "bob.martinez@example.com",
                        avatar: "https://images.squarespace-cdn.com/content/v1/590beb9b893fc0ef1a3523e3/1658676395992-9OIQSDIHPL3PQS14IVC6/RC?format=1500w"
                    ),
                    card: Card(
                        cardNumber: "**** **** **** 9876",
                        cardType: "MasterCard"
                    ),
                    lastTransfer: "2022-08-31T15:24:16Z",
                    note: "Dinner reimbursement",
                    moreInfo: MoreInfo(
                        numberOfTransfers: 5,
                        totalTransfer: 450
                    )
                ),
                Transfer(
                    person: Person(
                        fullName: "Clara \(page) Lee",
                        email: "clara.lee@example.com",
                        avatar: "https://images.squarespace-cdn.com/content/v1/590beb9b893fc0ef1a3523e3/1658676352637-1K6JK547ZU2L928STUKM/Maria-21-Edit.jpg?format=1500w"
                    ),
                    card: Card(
                        cardNumber: "**** **** **** 1122",
                        cardType: "Amex"
                    ), lastTransfer: "2022-08-31T15:24:16Z",
                    note: "Project expense split",
                    moreInfo: MoreInfo(
                        numberOfTransfers: 8,
                        totalTransfer: 2200
                    )
                ),
                Transfer(
                    person: Person(
                        fullName: "David \(page) Chen",
                        email: "david.chen@example.com",
                        avatar: "https://images.squarespace-cdn.com/content/v1/590beb9b893fc0ef1a3523e3/1658676793533-RHPWC0VZL03GZVOY9WPI/Lou-22-Edit.jpg?format=1500w"
                    ),
                    card: Card(
                        cardNumber: "**** **** **** 3344",
                        cardType: "Discover"
                    ),
                    lastTransfer: "2022-08-31T15:24:16Z",
                    note: "Gift transfer",
                    moreInfo: MoreInfo(
                        numberOfTransfers: 3,
                        totalTransfer: 300
                    )
                ),
                Transfer(
                    person: Person(
                        fullName: "Emma \(page) Thompson",
                        email: "alice.johnson@example.com",
                        avatar: "https://images.squarespace-cdn.com/content/v1/590beb9b893fc0ef1a3523e3/1658676534970-2Q1WYKZGJ571C2N50WWY/Sammy-19.jpg?format=1500w"
                    ),
                    card: Card(
                        cardNumber: "**** **** **** 4321",
                        cardType: "Visa"
                    ),
                    lastTransfer: "2022-08-31T15:24:16Z",
                    note: "Monthly rent payment",
                    moreInfo: MoreInfo(
                        numberOfTransfers: 12,
                        totalTransfer: 12000
                    )
                ),
                Transfer(
                    person: Person(
                        fullName: "Noah \(page) Brown",
                        email: "bob.martinez@example.com",
                        avatar: "https://images.squarespace-cdn.com/content/v1/590beb9b893fc0ef1a3523e3/1658676395992-9OIQSDIHPL3PQS14IVC6/RC?format=1500w"
                    ),
                    card: Card(
                        cardNumber: "**** **** **** 9876",
                        cardType: "MasterCard"
                    ),
                    lastTransfer: "2022-08-31T15:24:16Z",
                    note: "Dinner reimbursement",
                    moreInfo: MoreInfo(
                        numberOfTransfers: 5,
                        totalTransfer: 450
                    )
                ),
                Transfer(
                    person: Person(
                        fullName: "Olivia \(page) Davis",
                        email: "clara.lee@example.com",
                        avatar: "https://images.squarespace-cdn.com/content/v1/590beb9b893fc0ef1a3523e3/1658676352637-1K6JK547ZU2L928STUKM/Maria-21-Edit.jpg?format=1500w"
                    ),
                    card: Card(
                        cardNumber: "**** **** **** 1122",
                        cardType: "Amex"
                    ), lastTransfer: "2022-08-31T15:24:16Z",
                    note: "Project expense split",
                    moreInfo: MoreInfo(
                        numberOfTransfers: 8,
                        totalTransfer: 2200
                    )
                ),
                Transfer(
                    person: Person(
                        fullName: "Ethan \(page) Wilson",
                        email: "david.chen@example.com",
                        avatar: "https://images.squarespace-cdn.com/content/v1/590beb9b893fc0ef1a3523e3/1658676793533-RHPWC0VZL03GZVOY9WPI/Lou-22-Edit.jpg?format=1500w"
                    ),
                    card: Card(
                        cardNumber: "**** **** **** 3344",
                        cardType: "Discover"
                    ),
                    lastTransfer: "2022-08-31T15:24:16Z",
                    note: "Gift transfer",
                    moreInfo: MoreInfo(
                        numberOfTransfers: 3,
                        totalTransfer: 300
                    )
                ),
                Transfer(
                    person: Person(
                        fullName: "Sophia \(page) Garcia",
                        email: "alice.johnson@example.com",
                        avatar: "https://images.squarespace-cdn.com/content/v1/590beb9b893fc0ef1a3523e3/1658676534970-2Q1WYKZGJ571C2N50WWY/Sammy-19.jpg?format=1500w"
                    ),
                    card: Card(
                        cardNumber: "**** **** **** 4321",
                        cardType: "Visa"
                    ),
                    lastTransfer: "2022-08-31T15:24:16Z",
                    note: "Monthly rent payment",
                    moreInfo: MoreInfo(
                        numberOfTransfers: 12,
                        totalTransfer: 12000
                    )
                ),
                Transfer(
                    person: Person(
                        fullName: "Liam \(page) Anderson",
                        email: "bob.martinez@example.com",
                        avatar: "https://images.squarespace-cdn.com/content/v1/590beb9b893fc0ef1a3523e3/1658676395992-9OIQSDIHPL3PQS14IVC6/RC?format=1500w"
                    ),
                    card: Card(
                        cardNumber: "**** **** **** 9876",
                        cardType: "MasterCard"
                    ),
                    lastTransfer: "2022-08-31T15:24:16Z",
                    note: "Dinner reimbursement",
                    moreInfo: MoreInfo(
                        numberOfTransfers: 5,
                        totalTransfer: 450
                    )
                ),
                Transfer(
                    person: Person(
                        fullName: "Ava \(page) Martinez",
                        email: "clara.lee@example.com",
                        avatar: "https://images.squarespace-cdn.com/content/v1/590beb9b893fc0ef1a3523e3/1658676352637-1K6JK547ZU2L928STUKM/Maria-21-Edit.jpg?format=1500w"
                    ),
                    card: Card(
                        cardNumber: "**** **** **** 1122",
                        cardType: "Amex"
                    ), lastTransfer: "2022-08-31T15:24:16Z",
                    note: "Project expense split",
                    moreInfo: MoreInfo(
                        numberOfTransfers: 8,
                        totalTransfer: 2200
                    )
                ),
                Transfer(
                    person: Person(
                        fullName: "James \(page) Robinson",
                        email: "david.chen@example.com",
                        avatar: "https://images.squarespace-cdn.com/content/v1/590beb9b893fc0ef1a3523e3/1658676793533-RHPWC0VZL03GZVOY9WPI/Lou-22-Edit.jpg?format=1500w"
                    ),
                    card: Card(
                        cardNumber: "**** **** **** 3344",
                        cardType: "Discover"
                    ),
                    lastTransfer: "2022-08-31T15:24:16Z",
                    note: "Gift transfer",
                    moreInfo: MoreInfo(
                        numberOfTransfers: 3,
                        totalTransfer: 300
                    )
                )
            ]
        }
        switch page {
        case 5: return []
        default: return transfers
        }
    }
}
