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
    
}

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
        nameLabel.textColor = .appOperator2

    }
    func configCell(name: String) {
        nameLabel.text = name
    }
}
