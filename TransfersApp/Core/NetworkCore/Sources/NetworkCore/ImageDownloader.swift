//
//  ImageDownloader.swift
//  NetworkCore
//
//  Created by AREM on 10/31/25.
//

import UIKit

public final actor ImageDownloader {
    
    public static let shared = ImageDownloader()
    private init() {}
    
    private var cache = NSCache<NSString, UIImage>()
    
    public func downloadImage(from urlString: String) async throws -> UIImage? {
        if let cached = cache.object(forKey: urlString as NSString) {
            return cached
        }
        
        guard let url = URL(string: urlString) else {
            throw URLError(.badURL)
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }
        
        guard let image = UIImage(data: data) else {
            throw URLError(.cannotDecodeContentData)
        }
        
        cache.setObject(image, forKey: urlString as NSString)
        return image
    }
}
