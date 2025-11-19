//
//  TransferCell.swift
//  TransfersApp
//
//  Created by AREM on 10/30/25.
//

import UIKit
import Shared
import NetworkCore

// MARK: - Protocol
protocol TransferCellShowable {
    var name: String { get }
    var date: Date { get }
    var dateString: String { get }
    var amount: Int { get }
    var amountString: String { get }
    var avatarURLString: String? { get }
}

// MARK: - TransferCell
final class TransferCell: UITableViewCell {

    // MARK: - Outlets
    @IBOutlet private weak var parentView: UIView!
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var dateLabel: UILabel!
    @IBOutlet private weak var amountLabel: UILabel!
    @IBOutlet private weak var avatarParentView: UIView!
    @IBOutlet private weak var avatarImageView: UIImageView!
    @IBOutlet private weak var starImageView: UIImageView!

    private var avatarTask: Task<Void, Never>?
    private let avatarLoader = UIActivityIndicatorView(style: .medium)

    // MARK: - Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
//        TODO: Check This
        Task { @MainActor in
            setupUI()
        }
    }

    // MARK: - Setup UI
    private func setupUI() {
        // Parent container
        parentView.backgroundColor = .background1
        parentView.layer.cornerRadius = 16
        parentView.layer.borderWidth = 1
        parentView.layer.borderColor = UIColor.border2.cgColor
        
        // Name Label
        nameLabel.textColor = .text1
        nameLabel.font = .systemFont(ofSize: 20, weight: .bold)

        // Date Label
        dateLabel.textColor = .text8
        dateLabel.font = .systemFont(ofSize: 8, weight: .semibold)
        
        // Amount Label
        amountLabel.textColor = .text1
        amountLabel.font = .systemFont(ofSize: 12, weight: .regular)
        
        // Avatar Parent View (Container)
        avatarParentView.clipsToBounds = true
        avatarParentView.layer.cornerRadius = 15
        avatarParentView.layer.borderWidth = 1
        avatarParentView.layer.borderColor = UIColor.background1.cgColor
        
        // Avatar Image View
        avatarImageView.tintColor = .background3
        avatarImageView.contentMode = .scaleAspectFill
        avatarImageView.image = UIImage(systemName: "person.and.background.dotted")
        
        // Star Image View
        starImageView.image = UIImage.shared(named: "StarFill")
        starImageView.tintColor = .starColor

        // Loader
        avatarLoader.translatesAutoresizingMaskIntoConstraints = false
        avatarParentView.addSubview(avatarLoader)

        NSLayoutConstraint.activate([
            avatarLoader.centerXAnchor.constraint(equalTo: avatarParentView.centerXAnchor),
            avatarLoader.centerYAnchor.constraint(equalTo: avatarParentView.centerYAnchor)
        ])
    }

    private func resetUI() {
        avatarImageView.image = UIImage(systemName: "person.and.background.dotted")
        avatarLoader.stopAnimating()
        nameLabel.text = nil
        dateLabel.text = nil
        amountLabel.text = nil
        starImageView.isHidden = true
    }

    // MARK: - Configure
    func configCell(data: TransferCellShowable, isFavorite: Bool) {
        nameLabel.text = data.name
        dateLabel.text = "Last Transfer: \(data.dateString)"
        amountLabel.text = data.amountString
        starImageView.isHidden = !isFavorite
        loadAvatar(from: data.avatarURLString)
    }

    // MARK: - Avatar
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
