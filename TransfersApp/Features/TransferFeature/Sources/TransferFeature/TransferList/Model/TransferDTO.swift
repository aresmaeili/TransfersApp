//
//  TransferDTO.swift
//  TransferFeature
//
//  Created by AREM on 10/30/25.
//

import Foundation

// MARK: - Remote Models (mirror the API payload exactly)

struct Transfer: Codable, Equatable, Sendable {
    let person: Person?
    let card: Card?
    let note: String?
    let lastTransfer: String?
    let moreInfo: MoreInfo?

    private enum CodingKeys: String, CodingKey {
        case person
        case card
        case note
        case lastTransfer = "last_transfer"
        case moreInfo = "more_info"
    }
}

extension Transfer: TransferCellShowable {
    var avatar: String? {
        person?.avatar
    }
    
    var name: String {
        person?.fullName ?? "-"
    }

    var date: Date {
        Date()
    }
    
    var amount: String {
        ""
    }
    
    
}
struct Card: Codable, Equatable, Sendable {
    let cardNumber: String?
    let cardType: String?

    private enum CodingKeys: String, CodingKey {
        case cardNumber = "card_number"
        case cardType = "card_type"
    }

    /// Returns the card number Masked(e.g., **** 1234).
    var maskedNumber: String? {
        guard let number = cardNumber?.trimmingCharacters(in: .whitespacesAndNewlines), number.count >= 4 else { return nil }
        return "**** " + number.suffix(4)
    }
}

struct MoreInfo: Codable, Equatable, Sendable {
    let numberOfTransfers: Int?
    let totalTransfer: Int?
}

struct Person: Codable, Equatable, Sendable {
    let fullName: String?
    let email: String?
    let avatar: String?
    private enum CodingKeys: String, CodingKey {
        case fullName = "full_name"
        case email
        case avatar
    }
}

struct TransferDTO: Decodable {
    let id: String
    let name: String
    let date: String
    let amount: Double
    let isFavorite: Bool
    let imageURL: String?
}

//extension TransferDTO {
//    func toDomain() -> TransferDTO {
//        TransferDTO(
//    }
//}

import UIKit

extension UIImage {
    convenience init?(url urlString: String) async throws {
        guard let url = URL(string: urlString) else {
            return nil
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200 else {
            return nil
        }
        
        guard let image = UIImage(data: data) else {
            return nil
        }
        
        self.init(cgImage: image.cgImage!)
    }
}
