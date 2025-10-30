//
//  NetworkMethods.swift
//  TransfersApp
//
//  Created by AREM on 10/30/25.
//

// MARK: - HTTP Method
public enum HTTPMethod: String {
    case get     = "GET"
}

// MARK: - Headers & Query
public typealias HTTPHeaders = [String: String]
//public typealias QueryItems = [String: Any]

//// MARK: - Request Options
//public struct RequestOptions {
//    var headers: HTTPHeaders
//    var query: QueryItems?
//
//    public init(
//        headers: HTTPHeaders = ["Accept": "application/json"],
//        query: QueryItems? = nil,
//    ) {
//        self.headers = headers
//        self.query = query
//    }
//}
