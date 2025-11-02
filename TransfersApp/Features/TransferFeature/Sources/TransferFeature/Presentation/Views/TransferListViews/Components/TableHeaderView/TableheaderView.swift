//
//  TableheaderView.swift
//  TransferFeature
//
//  Created by AREM on 11/1/25.
//

import UIKit
import Shared

class TableheaderView: UIView, ViewConnectable {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var actionButton: UIButton!
    
    weak var viewModel: TransferListViewModel?
    var action: ((String) -> Void)?
    
    required init(viewModel: TransferListViewModel, title: String, buttonTitle: String, action: Void) {
        
        super.init(frame: .zero)
        self.viewModel = viewModel
        initialize(title: title, buttonTitle: buttonTitle, action: action)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func initialize(title: String, buttonTitle: String, action: Void) {
        connectView(bundle: .module)
        //        self.actions = { action }
        setupView(title: title, buttonTitle: buttonTitle, action: action)
    }
    
    private func setupView(title: String, buttonTitle: String, action: Void) {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.font = .preferredFont(forTextStyle: .headline)
        titleLabel.textColor = .label
        titleLabel.textAlignment = .left
        titleLabel.text = title
        actionButton.translatesAutoresizingMaskIntoConstraints = false
        actionButton.setTitle(buttonTitle, for: .normal)
        actionButton.onTap {
            action
        }
    }
}
