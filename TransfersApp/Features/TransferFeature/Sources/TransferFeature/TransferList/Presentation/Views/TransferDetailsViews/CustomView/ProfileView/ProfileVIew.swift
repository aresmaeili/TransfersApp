//
//  CardView.swift
//  TransferFeature
//
//  Created by AREM on 10/31/25.
//
import UIKit
import Shared

protocol TransferDetailsProfileProtocol {
    var name: String { get }
    var avatarUser: String { get }
    var mail: String { get }
    var totalAmount: String { get }
    var note: String? { get }
}

class ProfileView: UIView, ViewConnectable {
    
    @IBOutlet weak var parentView: UIView!
    @IBOutlet weak var avatarParentView: UIView!
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var mailLabel: UILabel!
    @IBOutlet weak var totalLabel: UILabel!
//    @IBOutlet weak var mailLabel: UILabel!
//    @IBOutlet weak var mailLabel: UILabel!

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
        connectView(bundle: .module)
        setupView()
    }
    
    
    private func setupView() {
        parentView.backgroundColor = .appBackground1
        parentView.layer.cornerRadius = 32
        parentView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        parentView.clipsToBounds = true
        
        avatarParentView.layer.cornerRadius = 16
        avatarParentView.backgroundColor = .appBackground3
        avatarParentView.layer.borderColor = UIColor.appBorder1.cgColor
        avatarParentView.layer.borderWidth = 1
        avatarParentView.clipsToBounds = true
        
        avatarImageView.contentMode = .scaleAspectFill
        
        nameLabel.font = .systemFont(ofSize: 24, weight: .bold)
        nameLabel.textColor = .appText1

        mailLabel.font = .systemFont(ofSize: 20, weight: .medium)
        mailLabel.textColor = .appText3
        
        totalLabel.font = .systemFont(ofSize: 48, weight: .bold)
        totalLabel.textColor = .appText6
    }
    
    
    func configure() {
   
    }
}
