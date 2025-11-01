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
    var viewModel: TransferDetailsViewModel?
    var router: Coordinator?
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        
        
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .appBackground3
        appearance.titleTextAttributes = [.foregroundColor: UIColor.black]
        
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        navigationController?.navigationBar.tintColor = .white
        
        
        guard let transfer = viewModel?.transfer else { return }
        title = transfer.title
        let cardView = CardView()
        cardView.configure(with: transfer)
        stackView.addArrangedSubview(cardView)
        
        let profileView = ProfileView(data: transfer, delegate: self, isFavorite: viewModel?.isFavorite ?? false)
        stackView.addArrangedSubview(profileView)
        
        guard let items = viewModel?.items else { return }
        items.forEach { item in
            if !item.value.isEmpty {
                let itemView = ItemView()
                itemView.configure(with: item)
                stackView.addArrangedSubview(itemView)
            }
        }
        
        let noteView = NoteView()
        //        noteView.configure(with: transfer)
        stackView.addArrangedSubview(noteView)
    }
    
    deinit {
        print("TransferDetailsViewController deinit")
    }
}

extension TransferDetailsViewController: profileViewDelegate {
    func didSelectStarButton(transfer: Transfer, shouldBeFavorite: Bool) {
        viewModel?.addTransfersToFavorite(transfer: transfer, shouldBeFavorite: shouldBeFavorite)
    }
}
