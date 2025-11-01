//
//  TransferDetailsViewController.swift
//  TransferFeature
//
//  Created by AREM on 10/31/25.
//
import UIKit
import RouterCore

final class TransferDetailsViewController: UIViewController {
    
    // @IBOutlet
    @IBOutlet weak private var stackView: UIStackView!
    
    // Dependencies
    weak var viewModel: TransferDetailsViewModel?
    weak var router: Coordinator?
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        let cardView = CardView()
        stackView.addArrangedSubview(cardView)
        
        let profileView = ProfileView()
        stackView.addArrangedSubview(profileView)
        
        let itemView = ItemView()
        stackView.addArrangedSubview(itemView)
    }

 
}
