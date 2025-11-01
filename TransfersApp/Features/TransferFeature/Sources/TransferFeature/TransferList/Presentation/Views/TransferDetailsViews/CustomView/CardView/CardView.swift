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
}


class CardView: UIView, ViewConnectable {
    
    @IBOutlet weak var parentView: UIView!
    @IBOutlet weak var logoLabel: UILabel!
    @IBOutlet weak var maskedNumberLabel: UILabel!
    @IBOutlet weak var dueDateLabel: UILabel!
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var countLabel: UILabel!
    @IBOutlet weak var toggleFavoriteButton: UIButton!
    
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
        
        logoLabel.font = UIFont.systemFont(ofSize: 14, weight: .black).withTraits(.traitItalic)
        logoLabel.textColor = .appText11
        
        maskedNumberLabel.font = UIFont.systemFont(ofSize: 18, weight: .black)
        maskedNumberLabel.textColor = .appText11
        
        dueDateLabel.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        dueDateLabel.textColor = .appText11
        
        countLabel.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        countLabel.textColor = .appText11
        
        amountLabel.font = UIFont.systemFont(ofSize: 32, weight: .bold)
        amountLabel.textColor = .appText11
        
        toggleFavoriteButton.layer.cornerRadius = 4
        toggleFavoriteButton.clipsToBounds = true
        toggleFavoriteButton.backgroundColor = .appText11
        toggleFavoriteButton.setTitle("", for: .normal)
        toggleFavoriteButton.setImage( UIImage(systemName: isFavorite ? "star.fill" : "star"), for: .normal)
        toggleFavoriteButton.tintColor = .appOperator2
        toggleFavoriteButton.setTitleColor(.appText1, for: .normal)
        toggleFavoriteButton.addTarget(self, action: #selector(toggleFavorite), for: .touchUpInside)
    }
    
    @objc func toggleFavorite() {
        isFavorite.toggle()
        toggleFavoriteButton.setImage( UIImage(systemName: isFavorite ? "star.fill" : "star"), for: .normal)
    }
    
    func configure(with data: TransferDetailsCardProtocol) {
        maskedNumberLabel.text = data.maskedCardNumber
        dueDateLabel.text = data.lastTransferDate
        amountLabel.text = data.totalAmount
        countLabel.text = data.countOfTransfer
        logoLabel.text = data.cardTypeString
    }
}
