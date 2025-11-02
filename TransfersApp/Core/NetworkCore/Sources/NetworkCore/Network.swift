//
//  AnyEncodable.swift
//  TransfersApp
//
//  Created by AREM on 10/30/25.
//
//
import Foundation

public actor NetworkClient {
    // MARK: Shared
    public static let shared = NetworkClient()

    // MARK: Types
    public enum HTTPMethod: String { case GET, POST, PUT, PATCH, DELETE }

    public enum NetworkError: Error, CustomStringConvertible {
        case badURL
        case invalidResponse
        case http(status: Int, data: Data)
        case decoding(underlying: Error)
        case timeout
        case cancelled

        public var description: String {
            switch self {
            case .badURL: return "Bad URL"
            case .invalidResponse: return "Invalid response"
            case let .http(status, _): return "HTTP \(status)"
            case let .decoding(err): return "Decoding error: \(err)"
            case .timeout: return "Request timed out"
            case .cancelled: return "Request cancelled"
            }
        }
    }

    public struct RequestOptions {
        public var headers: [String: String] = [:]
        public var queryItems: [URLQueryItem] = []
        /// Per-request max time (seconds). Defaults to 30 if nil.
        public var timeout: TimeInterval? = 30
        public var body: Data? = nil

        public init(
            headers: [String: String] = [:],
            queryItems: [URLQueryItem] = [],
            timeout: TimeInterval? = 30,
            body: Data? = nil
        ) {
            self.headers = headers
            self.queryItems = queryItems
            self.timeout = timeout
            self.body = body
        }
    }

    // MARK: Stored
    private let session: URLSession

    /// You can inject a custom session for tests.
    public init(
        session: URLSession? = nil,
        requestTimeout: TimeInterval = 30,
        resourceTimeout: TimeInterval = 60
    ) {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = requestTimeout   // idle-data timeout
        configuration.timeoutIntervalForResource = resourceTimeout // overall transfer timeout
        self.session = session ?? URLSession(configuration: configuration)
    }

    // MARK: Public – Convenience typed methods

    @discardableResult
    public func get<T: Decodable>(
        _ type: T.Type = T.self,
        endPoint: Endpoint,
        headers: [String: String] = [:],
        queryItems: [URLQueryItem] = [],
        timeout: TimeInterval? = 30,
        decoder: JSONDecoder = JSONDecoder()
    ) async throws -> T {
        try await request(
            T.self,
            endPoint: endPoint,
            method: .GET,
            options: .init(headers: headers, queryItems: queryItems, timeout: timeout),
            decoder: decoder
        )
    }

    @discardableResult
    public func post<T: Decodable, Body: Encodable>(
        _ type: T.Type = T.self,
        endPoint: Endpoint,
        body: Body,
        headers: [String: String] = [:],
        queryItems: [URLQueryItem] = [],
        timeout: TimeInterval? = 30,
        encoder: JSONEncoder = JSONEncoder(),
        decoder: JSONDecoder = JSONDecoder()
    ) async throws -> T {
        let data = try encoder.encode(body)
        var headers = headers
        if headers["Content-Type"] == nil { headers["Content-Type"] = "application/json" }
        return try await request(
            T.self,
            endPoint: endPoint,
            method: .POST,
            options: .init(headers: headers, queryItems: queryItems, timeout: timeout, body: data),
            decoder: decoder
        )
    }

    @discardableResult
    public func put<T: Decodable, Body: Encodable>(
        _ type: T.Type = T.self,
        endPoint: Endpoint,
        body: Body,
        headers: [String: String] = [:],
        queryItems: [URLQueryItem] = [],
        timeout: TimeInterval? = 30,
        encoder: JSONEncoder = JSONEncoder(),
        decoder: JSONDecoder = JSONDecoder()
    ) async throws -> T {
        let data = try encoder.encode(body)
        var headers = headers
        if headers["Content-Type"] == nil { headers["Content-Type"] = "application/json" }
        return try await request(
            T.self,
            endPoint: endPoint,
            method: .PUT,
            options: .init(headers: headers, queryItems: queryItems, timeout: timeout, body: data),
            decoder: decoder
        )
    }

    @discardableResult
    public func patch<T: Decodable, Body: Encodable>(
        _ type: T.Type = T.self,
        endPoint: Endpoint,
        body: Body,
        headers: [String: String] = [:],
        queryItems: [URLQueryItem] = [],
        timeout: TimeInterval? = 30,
        encoder: JSONEncoder = JSONEncoder(),
        decoder: JSONDecoder = JSONDecoder()
    ) async throws -> T {
        let data = try encoder.encode(body)
        var headers = headers
        if headers["Content-Type"] == nil { headers["Content-Type"] = "application/json" }
        return try await request(
            T.self,
            endPoint: endPoint,
            method: .PATCH,
            options: .init(headers: headers, queryItems: queryItems, timeout: timeout, body: data),
            decoder: decoder
        )
    }

    @discardableResult
    public func delete<T: Decodable>(
        _ type: T.Type = T.self,
        endPoint: Endpoint,
        headers: [String: String] = [:],
        queryItems: [URLQueryItem] = [],
        timeout: TimeInterval? = 30,
        decoder: JSONDecoder = JSONDecoder()
    ) async throws -> T {
        try await request(
            T.self,
            endPoint: endPoint,
            method: .DELETE,
            options: .init(headers: headers, queryItems: queryItems, timeout: timeout),
            decoder: decoder
        )
    }

    // MARK: Public – Raw variant (Data + HTTPURLResponse)
    public func requestRaw(
        endPoint: Endpoint,
        method: HTTPMethod,
        options: RequestOptions = .init()
    ) async throws -> (Data, HTTPURLResponse) {
        let request = try buildRequest(endPoint: endPoint, method: method, options: options)
        logRequest(request)

        do {
            let (data, response): (Data, URLResponse) = try await runWithTimeout(seconds: options.timeout ?? 30) {
                try await self.session.data(for: request)
            }
            guard let http = response as? HTTPURLResponse else { throw NetworkError.invalidResponse }
            logResponse(http, data: data)

            guard (200..<300).contains(http.statusCode) else {
                throw NetworkError.http(status: http.statusCode, data: data)
            }
            return (data, http)
        } catch is CancellationError {
            throw NetworkError.cancelled
        }
    }

    // MARK: Core generic request
    public func request<T: Decodable>(
        _ type: T.Type = T.self,
        endPoint: Endpoint,
        method: HTTPMethod,
        options: RequestOptions = .init(),
        decoder: JSONDecoder = JSONDecoder()
    ) async throws -> T {
        let (data, _) = try await requestRaw(endPoint: endPoint, method: method, options: options)
        do {
            let value = try decoder.decode(T.self, from: data)
            print("🎯 [Decoded Model]: \(value)")
            return value
        } catch {
            print("⚠️ Decoding error: \(error)")
            throw NetworkError.decoding(underlying: error)
        }
    }

    // MARK: Helpers
    private func buildRequest(
        endPoint: Endpoint,
        method: HTTPMethod,
        options: RequestOptions
    ) throws -> URLRequest {
        guard let baseURL = URL(string: endPoint.fullPath) else { throw NetworkError.badURL }

        var components = URLComponents(url: baseURL, resolvingAgainstBaseURL: false) ?? URLComponents()
        if !options.queryItems.isEmpty {
            components.queryItems = (components.queryItems ?? []) + options.queryItems
        }
        guard let url = components.url else { throw NetworkError.badURL }

        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.allHTTPHeaderFields = options.headers
        request.httpBody = options.body

        if let timeout = options.timeout { request.timeoutInterval = timeout }

        // Sensible defaults
        if request.value(forHTTPHeaderField: "Accept") == nil {
            request.setValue("application/json", forHTTPHeaderField: "Accept")
        }
        if request.value(forHTTPHeaderField: "Content-Type") == nil, options.body != nil {
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        }

        return request
    }

    /// Races the URLSession call vs. a sleep to deliver a hard timeout error at `seconds`.
    private func runWithTimeout<T: Sendable>(
        seconds: TimeInterval,
        operation: @Sendable @escaping () async throws -> T
    ) async throws -> T {
        try await withThrowingTaskGroup(of: T.self) { group in
            group.addTask { try await operation() }
            group.addTask {
                try await Task.sleep(nanoseconds: UInt64(seconds * 1_000_000_000))
                throw NetworkError.timeout
            }
            defer { group.cancelAll() }
            return try await group.next()!
        }
    }

    // MARK: Logging (dev only)
    private func logRequest(_ request: URLRequest) {
        let urlString = request.url?.absoluteString ?? "nil"
        print("🌐 [Request] \(request.httpMethod ?? "") ---> \(urlString)")
        if let headers = request.allHTTPHeaderFields, !headers.isEmpty {
            print("🧾 [Headers] \(headers)")
        }
        if let body = request.httpBody, let text = String(data: body, encoding: .utf8) {
            print("📤 [Body]: \(text.prefix(500))")
        }
    }

    private func logResponse(_ response: HTTPURLResponse, data: Data) {
        print("✅ [Response] Status: \(response.statusCode)")
        if let text = String(data: data, encoding: .utf8) {
            print("📦 [Raw Response Body]:\n\(text.prefix(500))")
        }
    }
}

// MARK: - JSON Encoder/Decoder defaults
extension JSONDecoder {
    static var defaultSnakeCase: JSONDecoder {
        let d = JSONDecoder()
        d.keyDecodingStrategy = .convertFromSnakeCase
        return d
    }
}

extension JSONEncoder {
    static var defaultJSON: JSONEncoder {
        let e = JSONEncoder()
        e.keyEncodingStrategy = .convertToSnakeCase
        return e
    }
}
