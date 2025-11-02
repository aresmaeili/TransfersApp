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
