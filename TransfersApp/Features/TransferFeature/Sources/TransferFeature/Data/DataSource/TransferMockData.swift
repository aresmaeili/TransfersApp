//
//  TransferMockData.swift
//  TransferFeature
//
//  Created by AREM on 10/30/25.
//

import Foundation

// MARK: - TransferMockData

/// A mock data source for simulating paginated transfer responses.
/// Used for local development and UI previews without calling live APIs.
final class TransferMockData: TransferDataSource {
    
    // MARK: - API Simulation
    
    func fetchTransfers(page: Int) async throws -> [Transfer] {
        switch page {
        case 5:
            return []
        default:
            return makeTransfers(for: page)
        }
    }
    
    // MARK: - Private Helpers
    
    /// Generates a mock list of transfers for the given page.
    private func makeTransfers(for page: Int) -> [Transfer] {
        let transfers: [Transfer] = [
                    Transfer(
                        person: Person(
                            fullName: "Alice \(page) Johnson",
                            email: "alice.johnson@example.com",
                            avatar: "https://images.squarespace-cdn.com/content/v1/590beb9b893fc0ef1a3523e3/1658676534970-2Q1WYKZGJ571C2N50WWY/Sammy-19.jpg?format=1500w"
                        ),
                        card: Card(
                            cardNumber: "6232 4235 5642 4321",
                            cardType: "Visa"
                        ),
                        lastTransfer: "2024-01-10T09:15:00Z",
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
                            cardNumber: "6232 4235 5642 9876",
                            cardType: "MasterCard"
                        ),
                        lastTransfer: "2024-02-14T12:45:00Z",
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
                            cardNumber: "6232 4235 5642 1122",
                            cardType: "Amex"
                        ), lastTransfer: "2024-03-20T17:30:00Z",
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
                            cardNumber: "6232 4235 5642 3344",
                            cardType: "Discover"
                        ),
                        lastTransfer: "2024-04-25T08:00:00Z",
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
                            cardNumber: "6232 4235 5642 4321",
                            cardType: "Visa"
                        ),
                        lastTransfer: "2024-05-30T10:10:00Z",
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
                            cardNumber: "6232 4235 5642 9876",
                            cardType: "MasterCard"
                        ),
                        lastTransfer: "2024-06-05T14:20:00Z",
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
                            cardNumber: "6232 4235 5642 1122",
                            cardType: "Amex"
                        ), lastTransfer: "2024-07-12T18:40:00Z",
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
                            cardNumber: "6232 4235 5642 3344",
                            cardType: "Discover"
                        ),
                        lastTransfer: "2024-08-18T11:50:00Z",
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
                            cardNumber: "6232 4235 5642 4321",
                            cardType: "Visa"
                        ),
                        lastTransfer: "2024-09-22T09:05:00Z",
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
                            cardNumber: "6232 4235 5642 9876",
                            cardType: "MasterCard"
                        ),
                        lastTransfer: "2024-10-28T13:30:00Z",
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
                            cardNumber: "6232 4235 5642 1122",
                            cardType: "Amex"
                        ), lastTransfer: "2024-11-05T16:45:00Z",
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
                            cardNumber: "6232 4235 5642 3344",
                            cardType: "Discover"
                        ),
                        lastTransfer: "2024-12-15T19:55:00Z",
                        note: "Gift transfer to sister in LA - $100 USD - 12/15/2024 - Pending Approval - #2345 - Transfer ID: 123456789 - Reference: 123456789 - Description: Gift for sister in LA - 12/15/2024 Gift transfer to sister in LA - $100 USD - 12/15/2024 - Pending Approval - #2345 - Transfer ID: 123456789 - Reference: 123456789 - Description: Gift for sister in LA - 12/15/2024",
                        moreInfo: MoreInfo(
                            numberOfTransfers: 3,
                            totalTransfer: 300
                        )
                    )
                ]
            
        return transfers
        
        }
    }
