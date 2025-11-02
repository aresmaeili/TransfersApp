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
    @IBOutlet private weak var starImageView: UIImageView!
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet weak var removeButton: UIButton!
    
    @IBAction func removeButtonAction(_ sender: Any) {
        guard let viewModel, let transfer else { return }
        viewModel.toggleFavoriteStatus(for: transfer)
        onUpdate?()
    }
    
    weak var viewModel: TransferListViewModelInput?
    var transfer: Transfer?
    var onUpdate: (() -> Void)?

    override func awakeFromNib() {
        super.awakeFromNib()
        MainActor.assumeIsolated {
            setupCell()
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        avatarTask?.cancel()
        avatarImageView.image = UIImage(systemName: "person.and.background.dotted")
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
        starImageView.image = UIImage.shared(named: "StarFill")
    }
    
    func configure(with transfer: Transfer, viewModel: TransferListViewModelInput) {
        self.viewModel = viewModel
        self.transfer = transfer
        nameLabel.text = transfer.person?.fullName ?? "-"
        guard let urlString = transfer.avatar else { return }
        loadAvatar(from: urlString)
        removeButton.isHidden = !viewModel.canEdit
    }
    
    private var avatarTask: Task<Void, Never>?
    
    func loadAvatar(from urlString: String?) {
        avatarTask?.cancel()
        avatarTask = Task {
            guard let urlString else { return }
            if let image = try? await ImageDownloader.shared.downloadImage(from: urlString) {
                await MainActor.run {
                    self.avatarImageView.image = image
                }
            }
        }
    }
}
