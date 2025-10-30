//
//  ViewController.swift
//  TransfersApp
//
//  Created by AREM on 10/30/25.
//

import UIKit
import TransferFeature

class ViewController: UIViewController {

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
    }

    // MARK: - UI Setup & Navigation
    private lazy var transfersButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Go to Transfers", for: .normal)
        button.backgroundColor = .systemBlue
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 8
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(navigateToTransfers), for: .touchUpInside)
        return button
    }()

    private func setupLayout() {
        view.addSubview(transfersButton)
        NSLayoutConstraint.activate([
            transfersButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            transfersButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            transfersButton.widthAnchor.constraint(equalToConstant: 200),
            transfersButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }

    /// Navigates to the Transfer List screen when the button is tapped.
    @objc private func navigateToTransfers() {
        let bundle = Bundle.transferFeature
        let storyboard = UIStoryboard(name: "TransferList", bundle: bundle)
        if let myVC = storyboard.instantiateViewController(withIdentifier: "TransferListViewController") as? TransferListViewController {
            navigationController?.pushViewController(myVC, animated: true)
        }
    }
}
