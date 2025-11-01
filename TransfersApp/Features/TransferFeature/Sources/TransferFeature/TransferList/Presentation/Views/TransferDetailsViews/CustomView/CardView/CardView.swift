//
//  CardView.swift
//  TransferFeature
//
//  Created by AREM on 10/31/25.
//

import UIKit
import Shared

protocol TransferDetailsCardProtocol {
    var cardTypeString: String { get }
    var cardNumberString: String { get }
    var maskedCardNumber: String { get }
    var lastTransferDate: String { get }
    var totalAmount: String { get }
    var countOfTransfer: String { get }
    var isFavorite: Bool { get }
    var name: String { get }
}


class CardView: UIView, ViewConnectable {
    
    @IBOutlet weak var parentView: UIView!
    @IBOutlet weak var logoLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var maskedNumberLabel: UILabel!
    @IBOutlet weak var dueDateLabel: UILabel!
    @IBOutlet weak var countLabel: UILabel!
    @IBOutlet weak var starImageView: UIImageView!

    
    var isFavorite: Bool = false

    required init() {
        
        super.init(frame: .zero)
        
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func initialize() {
        connectView(bundle: .module)
        setupView()
    }
    
    
    private func setupView() {
        parentView.backgroundColor = .appBackground5
        parentView.layer.cornerRadius = 22
        parentView.layer.borderWidth = 1
        parentView.layer.borderColor = UIColor.appBorder1.cgColor
        
        logoLabel.font = UIFont.systemFont(ofSize: 14, weight: .black)
        logoLabel.textColor = .appText11
        
        maskedNumberLabel.font = UIFont.systemFont(ofSize: 18, weight: .black)
        maskedNumberLabel.textColor = .appText11
        maskedNumberLabel.setCharacterSpacing(6)
        nameLabel.font = UIFont.systemFont(ofSize: 18, weight: .black)
        nameLabel.textColor = .appText11
        
        dueDateLabel.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        dueDateLabel.textColor = .appText11
        
        countLabel.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        countLabel.textColor = .appText11
        
        starImageView.image = UIImage.shared(named: "StarFill")

//        toggleFavoriteButton.addTarget(self, action: #selector(toggleFavorite), for: .touchUpInside)
    }
    
    @objc func toggleFavorite() {
        isFavorite.toggle()
    }
    
    func configure(with data: TransferDetailsCardProtocol) {
        maskedNumberLabel.text = data.maskedCardNumber
        dueDateLabel.text = data.lastTransferDate
        countLabel.text = "#" + data.countOfTransfer
        logoLabel.text = data.cardTypeString
        nameLabel.text = data.name
    }
}

extension UILabel {
    func setCharacterSpacing(_ spacing: CGFloat) {
        guard let text = self.text else { return }
        let attributedString = NSMutableAttributedString(string: text)
        attributedString.addAttribute(.kern, value: spacing, range: NSRange(location: 0, length: text.count))
        self.attributedText = attributedString
    }
}
