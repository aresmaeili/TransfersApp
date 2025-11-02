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
    
    // MARK: Outlets
    @IBOutlet private weak var parentView: UIView!
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var dateLabel: UILabel!
    @IBOutlet private weak var amountLabel: UILabel!
    @IBOutlet private weak var avatarParentView: UIView!
    @IBOutlet private weak var avatarImageView: UIImageView!
    @IBOutlet private weak var starImageView: UIImageView!
    
    // MARK: Lifecycle
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
    }
    
    // MARK: Setup
    private func setupUI() {
        // Parent View Styling
        parentView.backgroundColor = .background1
        parentView.layer.cornerRadius = 16
        parentView.layer.masksToBounds = true
        parentView.layer.borderWidth = 1
        parentView.layer.borderColor = UIColor.border2.cgColor
        
        // Name Label
        nameLabel.textColor = .text1
        nameLabel.font = .systemFont(ofSize: 20, weight: .bold)

        // Date Label
        dateLabel.textColor = .text8
        dateLabel.font = .systemFont(ofSize: 8, weight: .semibold)
        
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
    }
    
    // MARK: Configuration
    func configCell(data: TransferCellShowable, isFavorite: Bool) {
        nameLabel.text = data.name
        dateLabel.text = "Last Transfer: \(data.dateString)"
        amountLabel.text = data.amountString
        loadAvatar(from: data.avatarURLString)
        starImageView.isHidden = !isFavorite
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
