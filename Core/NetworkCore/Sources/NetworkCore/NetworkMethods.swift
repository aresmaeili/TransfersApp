//
//  NetworkMethods.swift
//  TransfersApp
//
//  Created by AREM on 10/30/25.
//

// MARK: - HTTP Method
public enum HTTPMethod: String {
    case get     = "GET"
    case post    = "POST"
}

// MARK: - Headers & Query
public typealias HTTPHeaders = [String: String]
