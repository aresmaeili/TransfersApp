//
//  NetworkClient.swift
//  TransfersApp
//
//  Created by AREM on 10/30/25.
//

import Foundation

// MARK: - NetworkClient

public actor NetworkClient {

    public static let shared = NetworkClient()

    private let session: URLSession

    public init(session: URLSession = .shared) {
        self.session = session
    }

    public func request<T: Decodable>(_ endpoint: Endpoint, decoder: JSONDecoder = JSONDecoder()) async throws -> T {

        let request = try buildRequest(from: endpoint)
        log("🌐 [Request] \(request)")

        let (data, response) = try await session.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse else {
            throw URLError(.badServerResponse)
        }

        log("✅ [Response] Status: \(httpResponse.statusCode)")
        logResponseBody(data)

        guard 200..<300 ~= httpResponse.statusCode else {
            throw URLError(.badServerResponse)
        }

        do {
            let decoded = try decoder.decode(T.self, from: data)
            log("🎯 [Decoded Model]: \(decoded)")
            return decoded
        } catch {
            log("⚠️ Decoding error: \(error)")
            throw error
        }
    }

    // MARK: - Build request
    private func buildRequest(from endpoint: Endpoint) throws -> URLRequest {

        guard let url = URL(string: endpoint.fullPath) else {
            throw URLError(.badURL)
        }

        var request = URLRequest(url: url)
        request.httpMethod = endpoint.method.rawValue
        request.httpBody = endpoint.body

        endpoint.headers?.forEach { request.setValue($1, forHTTPHeaderField: $0) }

        return request
    }

    // MARK: - Logging
    private func logResponseBody(_ data: Data) {
        guard let text = String(data: data, encoding: .utf8) else { return }
        let preview = text.count > 500 ? text.prefix(500) + "…" : text
        log("📦 [Raw Response]:\n\(preview)")
    }

    private func log(_ message: String) {
        print(message)
    }
}

// MARK: - Samples 

//struct GetUserEndpoint: Endpoint {
//    var host: String { "https://api.example.com" }
//    var path: String { "/user" }
//    var method: HTTPMethod { .GET }
//    var queryItems: [URLQueryItem]? { [ URLQueryItem(name: "id", value: "123") ] }
//}

//let user: User = try await NetworkClient.shared.request(GetUserEndpoint())

//struct CreateUserEndpoint: Endpoint {
//    var host: String { "https://api.example.com" }
//    var path: String { "/user" }
//    var method: HTTPMethod { .POST }
//
//    var body: Data? {
//        try? JSONEncoder().encode(["name": "Alice"])
//    }
//
//    var headers: [String : String]? {
//        ["Content-Type": "application/json"]
//    }
//
//    var queryItems: [URLQueryItem]? { nil }
//}

//let createdUser: User = try await NetworkClient.shared.request(CreateUserEndpoint())

