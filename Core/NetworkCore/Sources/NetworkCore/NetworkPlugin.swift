//
//  NetworkPlugin.swift
//  TransfersApp
//
//  Created by AREM on 10/30/25.
//

import Foundation

// MARK: - NetworkPlugin Protocol

/// A protocol that allows observing and reacting to network request events.
/// Plugins can be used for logging, metrics, authentication, etc.
public protocol NetworkPlugin {
    func willSend(request: URLRequest) async
    func didReceive(result: Result<(Data, URLResponse), Error>, for request: URLRequest) async
}

// MARK: - ConsoleLoggerPlugin

/// Logs request and response details to the console.
public struct ConsoleLoggerPlugin: NetworkPlugin {
    public init() {}
    
    public func willSend(request: URLRequest) async {
        let headers = request.allHTTPHeaderFields ?? [:]
        print("➡️", request.httpMethod ?? "-", request.url?.absoluteString ?? "-", "\nHeaders:", redact(headers))
        
        if let body = request.httpBody,
           let bodyString = String(data: body, encoding: .utf8),
           !bodyString.isEmpty {
            print("🧾 Body:", bodyString)
        }
    }
    
    public func didReceive(result: Result<(Data, URLResponse), Error>, for request: URLRequest) async {
        switch result {
        case .success(let (data, response)):
            let code = (response as? HTTPURLResponse)?.statusCode ?? 0
            print("⬅️ [\(code)]", request.url?.absoluteString ?? "-", "(\(data.count) bytes)")
            print("------------------------------------------------------------")
        case .failure(let error):
            print("❌", request.url?.absoluteString ?? "-", "error:", error.localizedDescription)
        }
    }
    
    private func redact(_ headers: [String: String]) -> [String: String] {
        var output = headers
        ["Authorization", "Cookie", "Set-Cookie"].forEach { key in
            if output[key] != nil {
                output[key] = "REDACTED"
            }
        }
        return output
    }
}

// MARK: - MetricsPlugin

/// Measures request duration and logs elapsed time.
public final actor MetricsPlugin: NetworkPlugin {
    private var startTimes: [String: CFAbsoluteTime] = [:]
    
    public init() {}
    
    public func willSend(request: URLRequest) async {
        let id = request.value(forHTTPHeaderField: "X-Request-ID") ?? UUID().uuidString
        startTimes[id] = CFAbsoluteTimeGetCurrent()
    }
    
    public func didReceive(result: Result<(Data, URLResponse), Error>, for request: URLRequest) async {
        let id = request.value(forHTTPHeaderField: "X-Request-ID") ?? "(none)"
        if let start = startTimes.removeValue(forKey: id) {
            let elapsed = (CFAbsoluteTimeGetCurrent() - start) * 1000
            print("⏱️ [Metrics] \(id) took \(Int(elapsed)) ms")
        }
    }
}

// MARK: - RequestIDPlugin

/// Logs or injects a request ID header for traceability.
public struct RequestIDPlugin: NetworkPlugin {
    public init() {}
    
    public func willSend(request: URLRequest) async {
        let id = request.value(forHTTPHeaderField: "X-Request-ID") ?? "(none)"
        print("🆔 Request-ID:", id)
    }
    
    public func didReceive(result: Result<(Data, URLResponse), Error>, for request: URLRequest) async {}
}

// MARK: - AuthDebugPlugin

/// Logs authorization headers (redacted for safety).
public final class AuthDebugPlugin: NetworkPlugin {
    public init() {}
    
    public func willSend(request: URLRequest) async {
        if let auth = request.value(forHTTPHeaderField: "Authorization") {
            print("🔐 Authorization:", auth.prefix(24), "…")
        } else {
            print("🔓 No Authorization header")
        }
    }
    
    public func didReceive(result: Result<(Data, URLResponse), Error>, for request: URLRequest) async {}
}

// MARK: - CurlLoggerPlugin

/// Generates and logs a `curl` command representation of the request.
public struct CurlLoggerPlugin: NetworkPlugin {
    public init() {}
    
    public func willSend(request: URLRequest) async {
        print(makeCurl(from: request))
    }
    
    public func didReceive(result: Result<(Data, URLResponse), Error>, for request: URLRequest) async {}
    
    private func makeCurl(from request: URLRequest) -> String {
        guard let url = request.url else { return "curl <invalid-url>" }
        
        var parts: [String] = ["curl", "\"\(url.absoluteString)\""]
        
        if let method = request.httpMethod, method != "GET" {
            parts += ["-X", method]
        }
        
        (request.allHTTPHeaderFields ?? [:]).forEach { key, value in
            parts += ["-H", "\"\(key): \(value)\""]
        }
        
        if let body = request.httpBody,
           !body.isEmpty,
           let bodyString = String(data: body, encoding: .utf8) {
            let escapedBody = bodyString.replacingOccurrences(of: "\"", with: "\\\"")
            parts += ["--data", "\"\(escapedBody)\""]
        }
        
        return parts.joined(separator: " ")
    }
}

// MARK: - ResponsePreviewPlugin

/// Logs a preview of the JSON or text response (up to a configurable limit).
public struct ResponsePreviewPlugin: NetworkPlugin {
    public let limit: Int
    
    public init(limit: Int = 2048) {
        self.limit = limit
    }
    
    public func willSend(request: URLRequest) async {}
    
    public func didReceive(result: Result<(Data, URLResponse), Error>, for request: URLRequest) async {
        guard case .success(let (data, _)) = result else { return }
        let snippet = data.prefix(limit)
        
        if let json = try? JSONSerialization.jsonObject(with: snippet),
           let prettyData = try? JSONSerialization.data(withJSONObject: json, options: [.prettyPrinted]),
           let jsonString = String(data: prettyData, encoding: .utf8) {
            print("📦 Response Preview:\n\(jsonString)")
        } else if let text = String(data: snippet, encoding: .utf8), !text.isEmpty {
            print("📦 Response Preview:\n\(text)")
        } else {
            print("📦 Response Preview: <binary> (\(snippet.count) bytes)")
        }
    }
}

// MARK: - RedactJSONKeysPlugin

/// Redacts sensitive JSON keys in request bodies before logging.
public struct RedactJSONKeysPlugin: NetworkPlugin {
    public let keys: Set<String>
    
    public init(keys: Set<String>) {
        self.keys = keys
    }
    
    public func willSend(request: URLRequest) async {
        guard let body = request.httpBody else { return }
        
        if var json = (try? JSONSerialization.jsonObject(with: body)) as? [String: Any] {
            var changed = false
            for key in keys where json[key] != nil {
                json[key] = "REDACTED"
                changed = true
            }
            if changed,
               let redactedData = try? JSONSerialization.data(withJSONObject: json, options: []),
               let redactedString = String(data: redactedData, encoding: .utf8) {
                print("🙈 Redacted Body:\n\(redactedString)")
            }
        }
    }
    
    public func didReceive(result: Result<(Data, URLResponse), Error>, for request: URLRequest) async {}
}
