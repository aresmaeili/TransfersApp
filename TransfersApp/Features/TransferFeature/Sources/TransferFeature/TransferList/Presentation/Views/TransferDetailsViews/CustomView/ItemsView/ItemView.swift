//
//  ItemsView.swift
//  TransferFeature
//
//  Created by AREM on 10/31/25.
//
import UIKit

class ItemView: UIView, ViewConnectable {
    
//    @IBOutlet weak var parentView: UIView!
//    @IBOutlet weak var avatarParentView: UIView!
//    @IBOutlet weak var avatarImageView: UIImageView!
//    @IBOutlet weak var nameLabel: UILabel!
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
        connectView()
        setupView()
    }
    
    
    private func setupView() {

    }
    
    
    func configure() {
   
    }
}
