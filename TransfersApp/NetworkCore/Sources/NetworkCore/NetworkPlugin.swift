//
//  NetworkPlugin.swift
//  TransfersApp
//
//  Created by AREM on 10/30/25.
//

import Foundation

// MARK: - Extra Plugins
public protocol NetworkPlugin {
    
    func willSend(request: URLRequest) async
    func didReceive(result: Result<(Data, URLResponse), Error>, for request: URLRequest) async
}

public struct ConsoleLoggerPlugin: NetworkPlugin {
    public init() {}
    public func willSend(request: URLRequest) async {
        #if DEBUG
        let headers = request.allHTTPHeaderFields ?? [:]
        print("➡️", request.httpMethod ?? "-", request.url?.absoluteString ?? "-", "\nHeaders:", redacted(headers))
        if let body = request.httpBody, let s = String(data: body, encoding: .utf8), !s.isEmpty {
            print("Body:", s)
        }
        #endif
    }
    public func didReceive(result: Result<(Data, URLResponse), Error>, for request: URLRequest) async {
        #if DEBUG
        switch result {
        case .success((let data, let response)):
            let code = (response as? HTTPURLResponse)?.statusCode ?? 0
            print("------------------------------------------------------------\n⬅️ [\(code)]", request.url?.absoluteString ?? "-", "size:", data.count)
        case .failure(let error):
            print("❌", request.url?.absoluteString ?? "-", "error:", error.localizedDescription)
        }
        #endif
    }
    private func redacted(_ h: [String: String]) -> [String: String] {
        var out = h
        ["Authorization", "Cookie", "Set-Cookie"].forEach { key in
            if out[key] != nil { out[key] = "REDACTED" }
        }
        return out
    }
}

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
            print("⏱️", id, "took", Int(elapsed), "ms")
        }
    }
}

public struct RequestIDPlugin: NetworkPlugin {
    public init() {}
    public func willSend(request: URLRequest) async {
        let id = request.value(forHTTPHeaderField: "X-Request-ID") ?? "(none)"
        print("🆔 Request-ID:", id)
    }
    public func didReceive(result: Result<(Data, URLResponse), Error>, for request: URLRequest) async {}
}

public final class AuthDebugPlugin: NetworkPlugin {
    public init() {}
    public func willSend(request: URLRequest) async {
        #if DEBUG
        if let auth = request.value(forHTTPHeaderField: "Authorization") {
            print("🔐 Authorization:", auth.prefix(24), "...")
        } else {
            print("🔓 No Authorization header")
        }
        #endif
    }
    public func didReceive(result: Result<(Data, URLResponse), Error>, for request: URLRequest) async {}
}

public struct CurlLoggerPlugin: NetworkPlugin {
    public init() {}
    public func willSend(request: URLRequest) async {
        #if DEBUG
        print(makeCurl(from: request))
        #endif
    }
    public func didReceive(result: Result<(Data, URLResponse), Error>, for request: URLRequest) async {}

    private func makeCurl(from request: URLRequest) -> String {
        guard let url = request.url else { return "curl <invalid-url>" }
        var parts: [String] = ["curl", "\"\(url.absoluteString)\""]
        if let method = request.httpMethod, method != "GET" { parts += ["-X", method] }
        (request.allHTTPHeaderFields ?? [:]).forEach { k, v in parts += ["-H", "\"\(k): \(v)\""] }
        if let body = request.httpBody, !body.isEmpty, let s = String(data: body, encoding: .utf8) {
            parts += ["--data", "\"\(s.replacingOccurrences(of: "\"", with: "\\\""))\""]
        }
        return parts.joined(separator: " ")
    }
}

public struct ResponsePreviewPlugin: NetworkPlugin {
    public let limit: Int
    public init(limit: Int = 2048) { self.limit = limit }
    public func willSend(request: URLRequest) async {}
    public func didReceive(result: Result<(Data, URLResponse), Error>, for request: URLRequest) async {
        #if DEBUG
        if case .success((let data, _)) = result {
            let snippet = data.prefix(limit)
            if let json = try? JSONSerialization.jsonObject(with: snippet),
               let pretty = try? JSONSerialization.data(withJSONObject: json, options: [.prettyPrinted]),
               let s = String(data: pretty, encoding: .utf8) {
                print("📦 Preview:\n", s)
            } else if let s = String(data: snippet, encoding: .utf8), !s.isEmpty {
                print("📦 Preview:\n", s)
            } else {
                print("📦 Preview: <binary> (\(snippet.count) bytes)")
            }
        }
        #endif
    }
}

public struct RedactJSONKeysPlugin: NetworkPlugin {
    public let keys: Set<String>
    public init(keys: Set<String>) { self.keys = keys }
    public func willSend(request: URLRequest) async {
        #if DEBUG
        guard let body = request.httpBody else { return }
        if var obj = (try? JSONSerialization.jsonObject(with: body)) as? [String: Any] {
            var changed = false
            for k in keys where obj[k] != nil { obj[k] = "REDACTED"; changed = true }
            if changed, let data = try? JSONSerialization.data(withJSONObject: obj, options: []) {
                if let s = String(data: data, encoding: .utf8) { print("🙈 Redacted Body:\n", s) }
            }
        }
        #endif
    }
    public func didReceive(result: Result<(Data, URLResponse), Error>, for request: URLRequest) async {}
}
