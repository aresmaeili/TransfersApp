//
//  Endpoint.swift
//  TransfersApp
//
//  Created by AREM on 10/30/25.


import Foundation

// MARK: - Endpoint Protocol
public protocol Endpoint {
    var host: String { get }
    var path: String { get }
    var method: HTTPMethod { get }
    var queryItems: [URLQueryItem]? { get }
//    var options: RequestOptions { get }
}

public extension Endpoint {
    var fullPath: String {
        var components = URLComponents(string: host)
        components?.path = path
        components?.queryItems = queryItems
        return components?.url?.absoluteString ?? host + path
    }
}

public struct TransferListEndpoint: Endpoint {
    public let page: Int

       public init(page: Int) {
           self.page = page
       }

    public var host: String {  "https://3642fee5-406d-487e-9022-65b1a71665b3.mock.pstmn.io" }
    public var path: String { "/transfer-list" }
    public var method: HTTPMethod { .get }
    public var queryItems: [URLQueryItem]? {
           [URLQueryItem(name: "page", value: "\(page)")]
       }
//    public var options: RequestOptions { .init() }
}
