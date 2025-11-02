//
//  CardView.swift
//  TransferFeature
//
//  Created by AREM on 10/31/25.
//

import UIKit
import Shared

// MARK: - Protocol

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

// MARK: - CardView

final class CardView: UIView, ViewConnectable {
    
    // MARK: - Outlets
    
    @IBOutlet private weak var parentView: UIView!
    @IBOutlet private weak var logoLabel: UILabel!
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var maskedNumberLabel: UILabel!
    @IBOutlet private weak var dueDateLabel: UILabel!
    @IBOutlet private weak var countLabel: UILabel!
    @IBOutlet private weak var starImageView: UIImageView!
    
    // MARK: - Properties
    
    private var isFavorite: Bool = false
    
    // MARK: - Initializers
    
    required init(with data: TransferDetailsCardProtocol) {
        super.init(frame: .zero)
        initialize(with: data)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup
    
    private func initialize(with data: TransferDetailsCardProtocol) {
        connectView(bundle: .module)
        setupView()
        configure(with: data)
    }
    
    private func setupView() {
        parentView.backgroundColor = .appBackground5
        parentView.layer.cornerRadius = 22
        parentView.layer.borderWidth = 1
        parentView.layer.borderColor = UIColor.appBorder1.cgColor
        
        setupLabels()
        setupStarIcon()
    }
    
    private func setupLabels() {
        logoLabel.font = .systemFont(ofSize: 14, weight: .black)
        logoLabel.textColor = .appText11
        
        maskedNumberLabel.font = .systemFont(ofSize: 18, weight: .black)
        maskedNumberLabel.textColor = .appText11
        maskedNumberLabel.setCharacterSpacing(6)
        
        nameLabel.font = .systemFont(ofSize: 18, weight: .black)
        nameLabel.textColor = .appText11
        
        dueDateLabel.font = .systemFont(ofSize: 14, weight: .regular)
        dueDateLabel.textColor = .appText11
        
        countLabel.font = .systemFont(ofSize: 14, weight: .regular)
        countLabel.textColor = .appText11
    }
    
    private func setupStarIcon() {
        starImageView.image = UIImage.shared(named: "StarFill")
    }
    
    // MARK: - Configuration
    
    private func configure(with data: TransferDetailsCardProtocol) {
        maskedNumberLabel.text = data.maskedCardNumber
        dueDateLabel.text = data.lastTransferDate
        countLabel.text = "#\(data.countOfTransfer)"
        logoLabel.text = data.cardTypeString
        nameLabel.text = data.name
        isFavorite = data.isFavorite
    }
}
