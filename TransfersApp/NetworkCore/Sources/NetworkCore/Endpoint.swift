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
    var options: RequestOptions { get }
}

public extension Endpoint {
    var fullPath: String { "\(host)\(path)" }
}

public struct TransferListEndpoint: Endpoint {
    public init() {}
    public var host: String {  "https://2f2e3046-0d87-4cb0-a44e-11eec03cf0fd.mock.pstmn.io" }
    public var path: String { "/transfer-list?page=1" }
    public var method: HTTPMethod { .get }
    public var options: RequestOptions { .init() }
}
