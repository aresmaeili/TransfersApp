//
//  Endpoint.swift
//  TransfersApp
//
//  Created by AREM on 10/30/25.


import Foundation

// MARK: - Endpoint Protocol
public protocol Endpoint {
    var baseUrl: String { get }
    var path: String { get }
    var method: HTTPMethod { get }
    var queryItems: [URLQueryItem]? { get }
    var headers: [String: String]? { get }
    var body: Data? { get }
}

public extension Endpoint {
    var headers: [String: String]? { nil }
    var body: Data? { nil }

    /// Compose full URL as string
    var fullPath: String {
        var components = URLComponents(string: baseUrl)
        components?.path = path
        components?.queryItems = queryItems
        return components?.url?.absoluteString ?? (baseUrl + path)
    }
}
