//
//  FavoriteCollectionViewCell.swift
//  Contacter
//
//  Created by AREM on 10/28/25.
//

import UIKit


class FavoriteCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var parentView: UIView!
    @IBOutlet private weak var circleView: UIView!
    @IBOutlet private weak var avatarImageView: UIImageView!
    @IBOutlet private weak var nameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        MainActor.assumeIsolated {
            setupCell()
        }
    }
    
    private func setupCell() {
        parentView.backgroundColor = .gray
        parentView.layer.cornerRadius = 20
        circleView.layer.cornerRadius = 32
        circleView.layer.masksToBounds = true
        circleView.backgroundColor = .appBackground3
        nameLabel.font = .systemFont(ofSize: 12)
        nameLabel.textColor = .secondaryLabel
        nameLabel.textAlignment = .center
        avatarImageView.contentMode = .scaleAspectFill
        avatarImageView.image = UIImage(systemName: "person.and.background.dotted")
        
    }
    
    func configure(with transfer: Transfer) {
        nameLabel.text = transfer.person?.fullName ?? "-"
        guard let urlString = transfer.avatar else { return }
        
        if let cachedImage = ImageCache.shared.image(forKey: urlString) {
            avatarImageView.image = cachedImage
            return
        }
        
        Task { [weak self] in
            guard let self else { return }
            do {
                guard let image = try await UIImage(url: urlString) else { return }
                ImageCache.shared.setImage(image, forKey: urlString)
                await MainActor.run {
                    self.avatarImageView.image = image
                }
            } catch {
                print("Error: \(error)")
            }
        }
    }
}

final class ImageCache {
    @MainActor static let shared = ImageCache()
    private let cache = NSCache<NSString, UIImage>()
    private init() {}
    
    func image(forKey key: String) -> UIImage? {
        return cache.object(forKey: key as NSString)
    }
    
    func setImage(_ image: UIImage, forKey key: String) {
        cache.setObject(image, forKey: key as NSString)
    }
}
