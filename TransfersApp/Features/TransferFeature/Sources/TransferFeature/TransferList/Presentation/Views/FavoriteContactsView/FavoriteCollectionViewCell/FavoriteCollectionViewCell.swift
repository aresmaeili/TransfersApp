//
//  FavoriteCollectionViewCell.swift
//  Contacter
//
//  Created by AREM on 10/28/25.
//

import UIKit
import NetworkCore
import Shared

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
        parentView.backgroundColor = .appBackground1
        parentView.layer.cornerRadius = 20
        parentView.layer.borderColor = UIColor.appBorder2.cgColor
        parentView.layer.borderWidth = 1
        
        circleView.layer.cornerRadius = 32
        circleView.layer.masksToBounds = true
        circleView.backgroundColor = .appBackground3
        circleView.layer.borderColor = UIColor.appBorder2.cgColor
        circleView.layer.borderWidth = 1
        
        nameLabel.font = .systemFont(ofSize: 16, weight: .bold)
        nameLabel.textColor = .appText1
        nameLabel.textAlignment = .center
        nameLabel.numberOfLines = 0
        
        
        avatarImageView.contentMode = .scaleAspectFill
        avatarImageView.layer.borderColor = UIColor.appBorder2.cgColor
        avatarImageView.layer.borderWidth = 1
        avatarImageView.image = UIImage(systemName: "person.and.background.dotted")
    }
    
    func configure(with transfer: Transfer) {
        nameLabel.text = transfer.person?.fullName ?? "-"
        guard let urlString = transfer.avatar else { return }
        
        if let cachedImage = ImageCache.shared.image(forKey: urlString) {
            avatarImageView.image = cachedImage
            return
        }
        
//        Todo: Change this loc
        Task { [weak self] in
            guard let self else { return }
            do {
                guard let image = try await ImageDownloader.shared.downloadImage(from: urlString)  else { return }
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
