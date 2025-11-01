//
//  TransferDTO.swift
//  TransferFeature
//
//  Created by AREM on 10/30/25.
//

import Foundation
import Shared

// MARK: - Remote Models (mirror the API payload exactly)
struct Transfer: Codable, Equatable, Sendable, Identifiable {
      let person: Person?
      let card: Card?
      let lastTransfer: String?
      let note: String?
      let moreInfo: MoreInfo?

      enum CodingKeys: String, CodingKey {
          case person, card
          case lastTransfer = "last_transfer"
          case note
          case moreInfo = "more_info"
      }
}

extension Transfer: TransferCellShowable {
    var avatarURLString: String? {
        person?.avatar ?? ""
    }
    
    var id: String {
        return (name + cardNo)
    }
    
    var cardNo: String {
        card?.cardNumber ?? "-"
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
    
    var amount: Int {
        moreInfo?.totalTransfer ?? 0
    }
    
    var amountString: String {
        moreInfo?.totalTransfer?.asMoneyString() ?? ""
    }
}

// MARK: - Card
struct Card: Codable, Equatable, Sendable {
        let cardNumber, cardType: String?

    enum CodingKeys: String, CodingKey {
        case cardNumber = "card_number"
        case cardType = "card_type"
    }
}

struct MoreInfo: Codable, Equatable, Sendable {
    let numberOfTransfers, totalTransfer: Int?

    enum CodingKeys: String, CodingKey {
        case numberOfTransfers = "number_of_transfers"
        case totalTransfer = "total_transfer"
    }
}

struct Person: Codable, Equatable, Sendable {
    let fullName: String?
     let email: String?
     let avatar: String?

     enum CodingKeys: String, CodingKey {
         case fullName = "full_name"
         case email, avatar
     }
}
