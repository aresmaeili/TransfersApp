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
    
    private var viewModel: TransferListViewModelInput?
    private var avatarTask: Task<Void, Never>?
    private let avatarLoader = UIActivityIndicatorView(style: .medium)
    private(set) var transfer: Transfer?
    var onUpdate: (() -> Void)?
    
    // MARK: - Lifecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        Task { @MainActor in
            setupUI()
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        avatarTask?.cancel()
        avatarImageView.image = UIImage(systemName: "person.and.background.dotted")
        avatarLoader.stopAnimating()
        nameLabel.text = nil
        transfer = nil
        viewModel = nil
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
    
    func configure(with transfer: Transfer, viewModel: TransferListViewModelInput) {
        self.viewModel = viewModel
        self.transfer = transfer
        nameLabel.text = transfer.person?.fullName ?? "-"

        UIView.transition(with: removeButton, duration: 0.25, options: .transitionCrossDissolve) { [weak self] in
            guard let self else { return }
            self.removeButton.isHidden = !viewModel.canEdit
            nameLabel.text = transfer.person?.fullName ?? "-"
            if let urlString = transfer.avatar {
                loadAvatar(from: urlString)
            }
        }
    }
    
    // MARK: - Actions
    
    @IBAction private func removeButtonAction(_ sender: UIButton) {
        guard let viewModel, let transfer else { return }
        viewModel.toggleFavoriteStatus(for: transfer)
        onUpdate?()
    }
    
    // MARK: - Avatar Loading
    
    private func loadAvatar(from urlString: String) {
        avatarLoader.startAnimating()
        avatarTask?.cancel()

        avatarTask = Task { [weak self] in
            guard let self else { return }

            self.avatarImageView.image = UIImage(systemName: "person.and.background.dotted")

            guard !urlString.isEmpty else {
                await MainActor.run { self.avatarLoader.stopAnimating() }
                return
            }

            if let image = try? await ImageDownloader.shared.downloadImage(from: urlString) {
                guard !Task.isCancelled else {
                    await MainActor.run { self.avatarLoader.stopAnimating() }
                    return
                }

                await MainActor.run {
                    self.avatarImageView.image = image
                    self.avatarLoader.stopAnimating()
                }
            } else {
                await MainActor.run { self.avatarLoader.stopAnimating() }
            }
        }
    }
}
