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
        
        navigationSetup()
        
        if let transfer = viewModel?.cardViewData {
            let cardView = CardView(with: transfer)
            stackView.addArrangedSubview(cardView)
        }
        
        if let viewModel {
            let profileView = ProfileView(viewModel: viewModel)
            stackView.addArrangedSubview(profileView)
        }
        
        if let items = viewModel?.detailItems {
            items.forEach { item in
                if !item.value.isEmpty {
                    let itemView = ItemView(with: item)
                    stackView.addArrangedSubview(itemView)
                }
            }
        }
        
        if let note = viewModel?.noteItem, !note.value.isEmpty {
            let noteView = NoteView(with: note)
            stackView.addArrangedSubview(noteView)
        }
    }
    
    func navigationSetup() {
        title = viewModel?.navigationTitle

        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .appBackground3
        appearance.titleTextAttributes = [.foregroundColor: UIColor.black]
        
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        navigationController?.navigationBar.tintColor = .white
    }
    
    deinit {
        print("TransferDetailsViewController deinit")
    }
}

