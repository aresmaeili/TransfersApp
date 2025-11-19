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
    
    public var baseUrl: String {  "https://e4253fd8-faab-456a-9f09-a2703d842875.mock.pstmn.io" }
    public var path: String { "/transfer-list" }
    public var method: HTTPMethod { .get }
    public var queryItems: [URLQueryItem]? {
        [URLQueryItem(name: "page", value: "\(page)")]
    }
}
