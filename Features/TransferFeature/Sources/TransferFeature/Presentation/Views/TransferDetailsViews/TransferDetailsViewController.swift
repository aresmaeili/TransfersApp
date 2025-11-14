//
//  TransferDetailsViewController.swift
//  TransferFeature
//
//  Created by AREM on 10/31/25.
//

import UIKit

// MARK: - TransferDetailsViewController

final class TransferDetailsViewController: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet private var backView: UIView!
    @IBOutlet private weak var stackView: UIStackView!
    
    // MARK: - Dependencies
    
    var viewModel: TransferDetailsViewModel?
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        guard previousTraitCollection?.userInterfaceStyle != traitCollection.userInterfaceStyle else { return }
        applyTheme()
    }

    // MARK: - UI Setup
    private func setupUI() {
        stackView.removeAllArrangedSubviews()
        backView.backgroundColor = .background1
        applyTheme()
        setupContent()
        bindViewModel() 
    }

    private func applyTheme() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .background3
        appearance.titleTextAttributes = [.foregroundColor: UIColor.text1]
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        navigationController?.navigationBar.compactAppearance = appearance
        stackView.backgroundColor = .background3
    }
    
    private func setupContent() {
        
        if let cardData = viewModel?.cardViewData {
            let cardView = CardView(with: cardData)
            stackView.addArrangedSubview(cardView)
        }
        
        let profileView = ProfileView(viewModel: viewModel)
        stackView.addArrangedSubview(profileView)
        
        if let items = viewModel?.detailItems {
            items.forEach { item in
                let itemView = ItemView(with: item)
                stackView.addArrangedSubview(itemView)
            }
        }
        
        if let note = viewModel?.noteItem, !note.value.isEmpty {
            let noteView = NoteView(with: note)
            stackView.addArrangedSubview(noteView)
        }
    }
    
    func bindViewModel() {
        guard let viewModel else { return }

        viewModel.onUpdate = { [weak self] in
            self?.setupUI()
        }
    }
    
    // MARK: - Deinitialization
    
    deinit {
        print("🧹 TransferDetailsViewController deinitialized")
    }
}
