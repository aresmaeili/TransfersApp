//
//  ItemsView.swift
//  TransferFeature
//
//  Created by AREM on 10/31/25.
//
import UIKit

protocol TransferDetailsItemsProtocol {
    var items: [TransferDetailsItemProtocol] { get }
}

protocol TransferDetailsItemProtocol {
    var icon: String { get }
    var title: String { get }
    var value: String { get }
}

class ItemView: UIView, ViewConnectable {
    
    @IBOutlet weak var parentView: UIView!
    @IBOutlet weak var iconParentView: UIView!
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var valueLabel: UILabel!

//    // MARK: - Init
//    required init?(coder aDecoder: NSCoder) {
//        super.init(coder: aDecoder)
//        setupView()
//    }
//
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        setupView()
//    }
    
    required init() {
        
        super.init(frame: .zero)
        
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func initialize() {
        connectView()
        setupView()
    }
    
    
    private func setupView() {
        parentView.backgroundColor = .appBackground1
        parentView.layer.cornerRadius = 16
        parentView.layer.borderColor = UIColor.appBorder1.cgColor
        parentView.layer.borderWidth = 1
        
        titleLabel.textColor = .appText1
        titleLabel.font = .systemFont(ofSize: 18, weight: .semibold)
        
        valueLabel.textColor = .appText10
        valueLabel.font = .systemFont(ofSize: 20, weight: .bold)
        
        iconParentView.backgroundColor = .appBackground5
        iconParentView.layer.cornerRadius = 16
        iconParentView.layer.borderColor = UIColor.appBorder1.cgColor
        iconParentView.layer.borderWidth = 1
        iconParentView.clipsToBounds = true
        
        iconImageView.contentMode = .scaleAspectFit
        
        
    }
    
    
    func configure() {
   
    }
}
