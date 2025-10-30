//
//  AnyEncodable.swift
//  TransfersApp
//
//  Created by AREM on 10/30/25.
//
//
import Foundation

public actor NetworkClient {
    public static let shared = NetworkClient()

    public func get<T: Decodable>(endPoint: Endpoint, decoder: JSONDecoder = JSONDecoder()) async throws -> T {
        
        // Validate URL
        guard let url = URL(string: endPoint.fullPath) else {
            throw URLError(.badURL)
        }

        print("🌐 [Request] GET \(url.absoluteString)")

        // Perform request
        let (data, response) = try await URLSession.shared.data(from: url)

        // Validate response
        guard let httpResponse = response as? HTTPURLResponse else {
            print("❌ Invalid response")
            throw URLError(.badServerResponse)
        }

        // Log response status
        print("✅ [Response] Status: \(httpResponse.statusCode)")

        // Log body preview
        if let text = String(data: data, encoding: .utf8) {
            print("📦 [Raw Response Body]:\n\(text.prefix(500))")
        }

        // Check status code
        guard (200..<300).contains(httpResponse.statusCode) else {
            throw URLError(.badServerResponse)
        }

        // Decode JSON
        do {
            let decoded = try decoder.decode(T.self, from: data)
            print("🎯 [Decoded Model]: \(decoded)")
            return decoded
        } catch {
            print("⚠️ Decoding error: \(error)")
            throw error
        }
    }
}
