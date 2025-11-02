//
//  ImageDownloader.swift
//  NetworkCore
//
//  Created by AREM on 10/31/25.
//

import UIKit

public actor ImageDownloader {
    public static let shared = ImageDownloader()
    
    private var cache = NSCache<NSString, UIImage>()
    private let session: URLSession

    var isCacheActive: Bool { true }
    
    init(session: URLSession = .shared) {
        self.session = session
    }

    public func downloadImage(from urlString: String) async throws -> UIImage? {
        if let cached = cache.object(forKey: urlString as NSString) , isCacheActive {
            return cached
        }
        
        guard let url = URL(string: urlString) else {
            return nil
        }
        
        let request = URLRequest(url: url, cachePolicy: .returnCacheDataElseLoad, timeoutInterval: 30)
        
        let (data, response) = try await session.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse,
              200..<300 ~= httpResponse.statusCode,
              let image = UIImage(data: data)
        else {
            return nil
        }
        
        cache.setObject(image, forKey: urlString as NSString)
        return image
    }
}
