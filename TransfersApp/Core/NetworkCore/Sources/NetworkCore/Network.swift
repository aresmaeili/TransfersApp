//
//  NetworkClient.swift
//  TransfersApp
//
//  Created by AREM on 10/30/25.
//

import Foundation

// MARK: - NetworkClient

/// A lightweight, async-safe networking client using Swift Concurrency.
public actor NetworkClient {
    
    // MARK: - Shared Instance
    
    public static let shared = NetworkClient()
    
    // MARK: - Properties
    
    private let session: URLSession
    
    // MARK: - Initialization
    
    public init(session: URLSession? = nil) {
        if let session = session {
            self.session = session
        } else {
            let configuration = URLSessionConfiguration.default
            configuration.timeoutIntervalForRequest = 30
            configuration.timeoutIntervalForResource = 60
            configuration.waitsForConnectivity = true
            self.session = URLSession(configuration: configuration)
        }
    }
    
    // MARK: - Networking Methods
    
    /// Performs a GET request to a given endpoint and decodes the response.
    ///
    /// - Parameters:
    ///   - endPoint: The API endpoint to request.
    ///   - decoder: The JSON decoder to use (default is `JSONDecoder()`).
    /// - Returns: A decoded model of type `T`.
    public func get<T: Decodable>(
        endPoint: Endpoint,
        decoder: JSONDecoder = JSONDecoder()
    ) async throws -> T {
        
        // Validate URL
        guard let url = URL(string: endPoint.fullPath) else {
            throw URLError(.badURL)
        }
        
        log("🌐 [Request] GET \(url.absoluteString)")
        
        // Perform request
        let (data, response) = try await session.data(from: url)
        
        // Validate response
        guard let httpResponse = response as? HTTPURLResponse else {
            log("❌ Invalid response")
            throw URLError(.badServerResponse)
        }
        
        log("✅ [Response] Status: \(httpResponse.statusCode)")
        logResponseBody(data)
        
        // Handle HTTP status codes
        guard 200..<300 ~= httpResponse.statusCode else {
            throw URLError(.badServerResponse)
        }
        
        // Decode JSON
        do {
            let decoded = try decoder.decode(T.self, from: data)
            log("🎯 [Decoded Model]: \(decoded)")
            return decoded
        } catch {
            log("⚠️ Decoding error: \(error)")
            throw error
        }
    }
    
    // MARK: - Private Helpers
    
    /// Logs response body safely (limited to 500 characters).
    private func logResponseBody(_ data: Data) {
        guard let text = String(data: data, encoding: .utf8) else { return }
        let preview = text.count > 500 ? text.prefix(500) + "…" : text
        log("📦 [Raw Response Body]:\n\(preview)")
    }
    
    /// Simple console logger (only active in debug builds).
    private func log(_ message: String) {
        print(message)
    }
}
