//
//  TransferAPI.swift
//  TransferFeature
//
//  Created by AREM on 10/30/25.
//

import Foundation
import NetworkCore

// MARK: - TransferDataSource

/// A protocol defining a common interface for fetching transfer data.
/// Both live APIs and mock data sources should conform to this.
protocol TransferDataSourceProtocol: Sendable {
    func fetchTransfers(page: Int) async throws -> [Transfer]
}

// MARK: - TransferAPI

/// Handles network calls for fetching transfer data from a remote API.
final class TransferAPI: TransferDataSourceProtocol {
    
    // MARK: - Properties
    
    private let client: NetworkClient
    
    // MARK: - Initialization
    
    init(client: NetworkClient = .shared) {
        self.client = client
    }
    
    // MARK: - API Call
    
    func fetchTransfers(page: Int) async throws -> [Transfer] {
        let endpoint = TransferListEndpoint(page: page)
        
        let post: Post = try await NetworkClient.shared.request(GetPostEndpoint())
        print(post)
        
        let posts: CreatedPost = try await NetworkClient.shared.request(CreatePostEndpoint())
        print(post)
        
        return try await client.request(endpoint)
    }
}


struct GetPostEndpoint: Endpoint {
    var host: String { "https://jsonplaceholder.typicode.com" }
    var path: String { "/posts/1" }
    var method: HTTPMethod { .get }
    var queryItems: [URLQueryItem]? { nil }
}

struct Post: Decodable {
    let userId: Int
    let id: Int
    let title: String
    let body: String
}

struct CreatePostEndpoint: Endpoint {

    var host: String { "https://jsonplaceholder.typicode.com" }
    var path: String { "/posts" }
    var method: HTTPMethod { .post }

    var body: Data? {
        try? JSONEncoder().encode(
            ["title": "Test Title", "body": "Hello API", "userId": "1"]
        )
    }

    var headers: [String : String]? {
        ["Content-Type": "application/json"]
    }

    var queryItems: [URLQueryItem]? { nil }
}

struct CreatedPost: Decodable {
    let id: Int
    let title: String
    let body: String
    let userId: String
}
