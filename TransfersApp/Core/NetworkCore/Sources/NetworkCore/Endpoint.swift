//
//  Endpoint.swift
//  TransfersApp
//
//  Created by AREM on 10/30/25.

import Foundation

// MARK: - Endpoint Protocol
public protocol Endpoint {
    /// Base URL or host
    var host: String { get }
    /// Path after the host (e.g., /users)
    var path: String { get }
    /// HTTP Method (GET, POST, DELETE, etc.)
    var method: HTTPMethod { get }
    /// Optional query items
    var queryItems: [URLQueryItem]? { get }
    /// Optional request headers
    var headers: [String: String]? { get }
    /// Optional request body (used for POST, PUT, PATCH)
    var body: Data? { get }
}

// MARK: - Default Implementations
public extension Endpoint {
    /// Default empty headers
    var headers: [String: String]? { nil }
    /// Default nil body
    var body: Data? { nil }

    /// Builds the full URL as a string (base + path + query)
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

    public var host: String {
        "https://2f2e3046-0d87-4cb0-a44e-11eec03cf0fd.mock.pstmn.io"
    }

    public var path: String { "/transfer-list" }

    public var method: HTTPMethod { .get }

    public var queryItems: [URLQueryItem]? {
        [URLQueryItem(name: "page", value: "\(page)")]
    }

    // Optional headers if needed
    public var headers: [String: String]? {
        ["Accept": "application/json"]
    }

    public var body: Data? { nil }
}

