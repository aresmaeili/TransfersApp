//
//  ItemView.swift
//  TransferFeature
//
//  Created by AREM on 10/31/25.
//

import UIKit
import Shared

// MARK: - Protocol

protocol TransferDetailsItemProtocol {
    var icon: String { get }
    var title: String { get }
    var value: String { get }
}

// MARK: - ItemView

final class ItemView: UIView, ViewConnectable {
    
    // MARK: - Outlets
    
    @IBOutlet private weak var backView: UIView!
    @IBOutlet private weak var parentView: UIView!
    @IBOutlet private weak var iconParentView: UIView!
    @IBOutlet private weak var iconImageView: UIImageView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var valueLabel: UILabel!
    
    // MARK: - Initializers
    
    required init(with data: TransferDetailsItemProtocol) {
        super.init(frame: .zero)
        initialize(with: data)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup
    
    private func initialize(with data: TransferDetailsItemProtocol) {
        connectView(bundle: .module)
        setupView()
        configure(with: data)
    }
    
    private func setupView() {
        setupParentView()
        setupLabels()
        setupIconContainer()
    }
    
    private func setupParentView() {
        backView.backgroundColor = .background1
        parentView.backgroundColor = .background1
        parentView.layer.cornerRadius = 16
        parentView.layer.borderWidth = 1
        parentView.layer.borderColor = UIColor.border1.cgColor
    }
    
    private func setupLabels() {
        titleLabel.textColor = .text3
        titleLabel.font = .systemFont(ofSize: 18, weight: .semibold)
        
        valueLabel.textColor = .text6
        valueLabel.font = .systemFont(ofSize: 20, weight: .bold)
    }
    
    private func setupIconContainer() {
        iconParentView.backgroundColor = .background5
        iconImageView.tintColor = .background1
        iconParentView.layer.cornerRadius = 16
        iconParentView.layer.borderWidth = 1
        iconParentView.layer.borderColor = UIColor.border5.cgColor
        iconParentView.clipsToBounds = true
        iconImageView.contentMode = .scaleAspectFit
    }
    
    // MARK: - Configuration
    
    private func configure(with data: TransferDetailsItemProtocol) {
        titleLabel.text = data.title
        valueLabel.text = data.value
        iconImageView.image = UIImage(systemName: data.icon)
    }
}
