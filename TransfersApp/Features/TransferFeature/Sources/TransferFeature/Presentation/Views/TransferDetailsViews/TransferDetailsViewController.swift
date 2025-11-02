//
//  TransferDetailsViewController.swift
//  TransferFeature
//
//  Created by AREM on 10/31/25.
//

import UIKit
import RouterCore

// MARK: - TransferDetailsViewController

final class TransferDetailsViewController: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet private weak var stackView: UIStackView!
    
    // MARK: - Dependencies
    
    var viewModel: TransferDetailsViewModel?
    var router: Coordinator?
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        updateNavigationBarAppearance(for: traitCollection.userInterfaceStyle)

    }
    
    public override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        
        if previousTraitCollection?.userInterfaceStyle != traitCollection.userInterfaceStyle {
            updateNavigationBarAppearance(for: traitCollection.userInterfaceStyle)
        }
    }
    
    // MARK: - Setup
    
    private func setupUI() {
        updateNavigationBarAppearance(for: traitCollection.userInterfaceStyle)
        setupContent()
    }
    
    private func updateNavigationBarAppearance(for style: UIUserInterfaceStyle) {
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
        
        // Card View
        if let cardData = viewModel?.cardViewData {
            let cardView = CardView(with: cardData)
            stackView.addArrangedSubview(cardView)
        }
        
        // Profile View
        let profileView = ProfileView(viewModel: viewModel)
        stackView.addArrangedSubview(profileView)
        
        // Item Views
        if let items = viewModel?.detailItems {
            items.forEach { item in
                let itemView = ItemView(with: item)
                stackView.addArrangedSubview(itemView)
            }
        }
        
        // Note View
        if let note = viewModel?.noteItem, !note.value.isEmpty {
            let noteView = NoteView(with: note)
            stackView.addArrangedSubview(noteView)
        }
    }
    
    // MARK: - Deinitialization
    
    deinit {
        print("🧹 TransferDetailsViewController deinitialized")
    }
}
