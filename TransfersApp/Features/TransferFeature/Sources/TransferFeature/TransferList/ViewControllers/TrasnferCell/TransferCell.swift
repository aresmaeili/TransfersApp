//
//  TransferCell.swift
//  TransfersApp
//
//  Created by AREM on 10/30/25.
//

import UIKit
import Shared

class TransferCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
//        TODO: check this
        Task { @MainActor in
            setupCell()
        }
    }
    
    func setupCell() {
        nameLabel.textColor = .appPrimary

    }
    func configCell(name: String) {
        nameLabel.text = name
    }
}
