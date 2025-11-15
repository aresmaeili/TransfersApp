//
//  FavoriteCollectionViewCell.swift
//  Contacter
//
//  Created by AREM on 10/28/25.
//

import UIKit
import NetworkCore
import Shared

// MARK: - FavoriteCollectionViewCell

final class FavoriteCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Outlets
    
    @IBOutlet private weak var parentView: UIView!
    @IBOutlet private weak var circleView: UIView!
    @IBOutlet private weak var avatarImageView: UIImageView!
    @IBOutlet private weak var starImageView: UIImageView!
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var removeButton: UIButton!
    
    // MARK: - Properties
    
    private var viewModel: FavoritesCellViewModelInput?
    private var avatarTask: Task<Void, Never>?
    private let avatarLoader = UIActivityIndicatorView(style: .medium)
    private(set) var transfer: Transfer?
    
    // MARK: - Lifecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        //        TODO: Check This
        Task { @MainActor in
            setupUI()
        }
    }
    
    // MARK: - Setup
    
    private func setupUI() {
        setupParentView()
        setupCircleView()
        setupNameLabel()
        setupAvatarImageView()
        setupStarImageView()
    }
    
    private func setupParentView() {
        parentView.backgroundColor = .background1
        parentView.layer.cornerRadius = 20
        parentView.layer.borderWidth = 2
        parentView.layer.borderColor = UIColor.border2.cgColor
    }
    
    private func setupCircleView() {
        circleView.backgroundColor = .background3
        circleView.layer.cornerRadius = 32
        circleView.layer.masksToBounds = true
        circleView.layer.borderWidth = 1
        circleView.layer.borderColor = UIColor.border2.cgColor
    }
    
    private func setupNameLabel() {
        nameLabel.font = .systemFont(ofSize: 16, weight: .bold)
        nameLabel.textColor = .text1
        nameLabel.textAlignment = .center
        nameLabel.numberOfLines = 0
    }
    
    private func setupAvatarImageView() {
        avatarImageView.contentMode = .scaleAspectFill
        avatarImageView.layer.borderWidth = 1
        avatarImageView.layer.borderColor = UIColor.border2.cgColor
        avatarImageView.image = UIImage(systemName: "person.and.background.dotted")
        avatarImageView.tintColor = .lightGray
        avatarLoader.translatesAutoresizingMaskIntoConstraints = false
        circleView.addSubview(avatarLoader)
        NSLayoutConstraint.activate([
            avatarLoader.centerXAnchor.constraint(equalTo: circleView.centerXAnchor),
            avatarLoader.centerYAnchor.constraint(equalTo: circleView.centerYAnchor)
        ])
    }
    
    private func setupStarImageView() {
        starImageView.image = UIImage.shared(named: "StarFill")
    }
    
    // MARK: - Configuration
    
    func configure(with transfer: Transfer, viewModel: FavoritesCellViewModelInput) {
        self.viewModel = viewModel
        self.transfer = transfer
        nameLabel.text = transfer.person?.fullName ?? "-"
        removeButton.isHidden = !viewModel.canEdit
        nameLabel.text = transfer.person?.fullName ?? "-"
        if let urlString = transfer.avatar {
            loadAvatar(from: urlString)
        }
    }
    
    // MARK: - Actions
    
    @IBAction private func removeButtonAction(_ sender: UIButton) {
        guard let viewModel, let transfer else { return }
        viewModel.toggleFavoriteStatus(for: transfer)
    }
    
    // MARK: - Avatar Loading
    private func loadAvatar(from urlString: String?) {
        avatarImageView.image = UIImage(systemName: "person.and.background.dotted")
        avatarTask?.cancel()
        avatarLoader.startAnimating()
        
        guard let urlString, !urlString.isEmpty else {
            avatarLoader.stopAnimating()
            return
        }
        
        avatarTask = Task { [weak self] in
            guard let self else { return }
            
            let image = try? await ImageDownloader.shared.downloadImage(from: urlString)
            guard !Task.isCancelled else { return }
            
            await MainActor.run {
                if let image {
                    self.avatarImageView.image = image
                }
                self.avatarLoader.stopAnimating()
            }
        }
    }
}
