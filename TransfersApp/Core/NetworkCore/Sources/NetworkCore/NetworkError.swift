
//  NetworkError.swift
//  TransfersApp
//
//  Created by AREM on 10/30/25.
//

import Foundation

enum NetworkError: Error, LocalizedError {
    case invalidURL
    case invalidResponse
    case decoding(underlying: DecodingError)
    case url(URLError)
    case timeout
    case cancelled
    case notFound
    case underlying(Error)

    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "آدرس نامعتبر است"
        case .invalidResponse:
            return "پاسخ معتبر از سرور دریافت نشد"
        case .decoding:
            return "خطا در پردازش/دیکد پاسخ سرور"
        case .timeout:
            return "مهلت درخواست به پایان رسید"

        case .cancelled:
            return "درخواست لغو شد"
        case .notFound:
            return "منبع موردنظر پیدا نشد (404)"
        case .url(let e):
            return e.localizedDescription
        case .underlying(let e):
            return e.localizedDescription
        }
    }

    // Optional helper for mapping a URLSession error to NetworkError
    static func map(_ error: Error) -> NetworkError {
        if let urlError = error as? URLError {
            switch urlError.code {
            case .timedOut:
                return .timeout
            case .cancelled:
                return .cancelled
            default:
                return .url(urlError)
            }
        } else if let decodingError = error as? DecodingError {
            return .decoding(underlying: decodingError)
        } else {
            return .underlying(error)
        }
    }
}
