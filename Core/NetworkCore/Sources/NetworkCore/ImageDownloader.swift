//
//  ImageDownloader.swift
//  NetworkCore
//
//  Created by AREM on 10/31/25.
//

import UIKit

// MARK: - ImageDownloader

/// A thread-safe image downloader with in-memory caching, using Swift concurrency.
public actor ImageDownloader {
    
    // MARK: - Shared Instance
    
    public static let shared = ImageDownloader()
    
    // MARK: - Properties
    
    private let cache = NSCache<NSString, UIImage>()
    private let session: URLSession
    private let cacheEnabled: Bool
    
    // MARK: - Initialization
    
    public init(session: URLSession = .shared, cacheEnabled: Bool = true) {
        self.session = session
        self.cacheEnabled = cacheEnabled
    }
    
    // MARK: - Image Downloading
    
    /// Downloads an image asynchronously, using an in-memory cache when possible.
    ///
    /// - Parameter urlString: The image URL as a string.
    /// - Returns: The downloaded `UIImage`, or `nil` if fetching fails.
    public func downloadImage(from urlString: String) async throws -> UIImage? {
        guard !urlString.isEmpty else { return nil }
        
        // Check cached image
        if cacheEnabled, let cached = cache.object(forKey: urlString as NSString) {
            return cached
        }
        
        // Validate URL
        guard let url = URL(string: urlString) else {
            return nil
        }
        
        // Perform network request
        let request = URLRequest(
            url: url,
            cachePolicy: .returnCacheDataElseLoad,
            timeoutInterval: 30
        )
        
        let (data, response) = try await session.data(for: request)
        
        // Validate response and image
        guard let httpResponse = response as? HTTPURLResponse,
              200..<300 ~= httpResponse.statusCode,
              let image = UIImage(data: data) else {
            return nil
        }
        
        // Cache and return image
        if cacheEnabled {
            cache.setObject(image, forKey: urlString as NSString)
        }
        return image
    }
    
    // MARK: - Cache Management
    
    /// Clears all cached images from memory.
    public func clearCache() {
        cache.removeAllObjects()
    }
    
    /// Returns the number of currently cached images.
    public func cacheCount() -> Int {
        return cache.totalCostLimit
    }
}
