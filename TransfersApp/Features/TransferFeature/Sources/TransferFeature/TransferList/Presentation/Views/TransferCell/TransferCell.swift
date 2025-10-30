//
//  TransferCell.swift
//  TransfersApp
//
//  Created by AREM on 10/30/25.
//

import UIKit
import Shared

protocol TransferCellShowable {
    var name: String { get }
    var date: Date { get }
    var amount: String { get }
    var avatar: String? { get }
}

class TransferCell: UITableViewCell {
    
    @IBOutlet weak var parentView: UIView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var avatarParentView: UIView!
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var starImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
//        TODO: check this
        setupCell()
        
    }
    
    func setupCell() {
        nameLabel.textColor = .appOperator2
        avatarImageView.tintColor = .appOperator2
        avatarImageView.contentMode = .scaleAspectFill
        avatarParentView.layer.cornerRadius = avatarParentView.bounds.height / 4
        avatarParentView.clipsToBounds = true
        parentView.layer.cornerRadius = parentView.bounds.height / 4
        parentView.layer.masksToBounds = true
        parentView.layer.borderWidth = 1
        parentView.layer.borderColor = UIColor.appOperator2.cgColor
        avatarParentView.layer.borderWidth = 1
        avatarParentView.layer.borderColor = UIColor.appOperator2.cgColor
        starImageView.image = UIImage(systemName: "star.circle")
        starImageView.tintColor = .appOperator2
    }
    
    func configCell(data: TransferCellShowable) {
        nameLabel.text = data.name
        dateLabel.text = DateFormatter.localizedString(from: data.date, dateStyle: .full, timeStyle: .none)
        amountLabel.text = data.amount
        avatarImageView.image = UIImage(systemName: "person.circle.fill")
        
        Task { [weak self] in
            guard let self else { return }
            do {
                let image = try await UIImage(url: data.avatar ?? "")
                await MainActor.run {
                    self.avatarImageView.image = image
                }
            } catch {
                return
            }
        }
    }
}
