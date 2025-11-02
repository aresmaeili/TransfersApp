//
//  TransferDTO.swift
//  TransferFeature
//
//  Created by AREM on 10/30/25.
//

import Foundation
import Shared

// MARK: - Remote Models (mirror the API payload exactly)
public struct Transfer: Codable, Equatable, Sendable, Identifiable, Hashable {
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

// MARK: - Card
public struct Card: Codable, Equatable, Sendable, Hashable {
        let cardNumber, cardType: String?

    enum CodingKeys: String, CodingKey {
        case cardNumber = "card_number"
        case cardType = "card_type"
    }
}

public struct MoreInfo: Codable, Equatable, Sendable, Hashable {
    let numberOfTransfers, totalTransfer: Int?

    enum CodingKeys: String, CodingKey {
        case numberOfTransfers = "number_of_transfers"
        case totalTransfer = "total_transfer"
    }
}

public struct Person: Codable, Equatable, Sendable, Hashable {
    let fullName: String?
     let email: String?
     let avatar: String?

     enum CodingKeys: String, CodingKey {
         case fullName = "full_name"
         case email, avatar
     }
}
