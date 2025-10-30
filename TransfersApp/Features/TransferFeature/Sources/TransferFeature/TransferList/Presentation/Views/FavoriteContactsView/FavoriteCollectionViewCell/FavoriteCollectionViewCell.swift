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
          parentView.backgroundColor = .gray
          parentView.layer.cornerRadius = 20
          circleView.layer.cornerRadius = 32
          circleView.layer.masksToBounds = true
          circleView.backgroundColor = .systemPink
          nameLabel.font = .systemFont(ofSize: 12)
          nameLabel.textColor = .secondaryLabel
          nameLabel.textAlignment = .center
          avatarImageView.contentMode = .scaleAspectFill
      }

      func configure(with contact: Transfer) {
          nameLabel.text = contact.person?.fullName ?? "-"
          Task { [weak self] in
              guard let self else { return }
              do {
                  let image = try await UIImage(url: contact.avatar ?? "")
                  await MainActor.run {
                      self.avatarImageView.image = image
                  }
              } catch {
                  return
              }
          }
      }
}
