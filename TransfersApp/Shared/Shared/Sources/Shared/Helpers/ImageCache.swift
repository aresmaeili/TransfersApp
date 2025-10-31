//
//  ImageCache.swift
//  Shared
//
//  Created by AREM on 10/31/25.
//

import UIKit

public final class ImageCache {
    @MainActor public static let shared = ImageCache()
    private let cache = NSCache<NSString, UIImage>()
    private init() {}
    
    public func image(forKey key: String) -> UIImage? {
        return cache.object(forKey: key as NSString)
    }
    
    public func setImage(_ image: UIImage, forKey key: String) {
        cache.setObject(image, forKey: key as NSString)
    }
}
