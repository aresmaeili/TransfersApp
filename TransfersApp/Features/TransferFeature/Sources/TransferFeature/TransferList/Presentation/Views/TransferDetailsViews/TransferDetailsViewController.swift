//
//  TransferDetailsViewController.swift
//  TransferFeature
//
//  Created by AREM on 10/31/25.
//
import UIKit
import RouterCore

final class TransferDetailsViewController: UIViewController {
    
    // Dependencies
    var viewModel: TransferDetailsViewModel?
    weak var router: Coordinator?
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bindViewModel()
    }
    
    private func setupUI() {
        self.title = "Transfer Details"
        // ... set up labels, etc.
    }

    private func bindViewModel() {
        // Example: Update a label
        // titleLabel.text = viewModel.title
        // amountLabel.text = viewModel.amountText
        // dateLabel.text = viewModel.dateText
    }
}
