//
//  TransferListEndpoint.swift
//  TransferFeature
//
//  Created by AREM on 11/2/25.
//
import NetworkCore
import Foundation

public struct TransferListEndpoint: Endpoint {
    public let page: Int
    
    public init(page: Int) {
        self.page = page
    }
    
    public var baseUrl: String {  "https://3642fee5-406d-487e-9022-65b1a71665b3.mock.pstmn.io" }
    public var path: String { "/transfer-list" }
    public var method: HTTPMethod { .get }
    public var queryItems: [URLQueryItem]? {
        [URLQueryItem(name: "page", value: "\(page)")]
    }
}
