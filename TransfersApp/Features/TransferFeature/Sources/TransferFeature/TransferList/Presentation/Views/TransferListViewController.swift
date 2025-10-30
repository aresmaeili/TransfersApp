//
//  TransferListViewController.swift
//  TransfersApp
//
//  Created by AREM on 10/30/25.
//

import UIKit
import NetworkCore
import RouterCore

public final class TransferListViewController: UIViewController {

    // MARK: - Outlets
    @IBOutlet private weak var transferTableView: UITableView!

    // MARK: - Properties
    var viewModel: TransferListViewModel?
    var router: Coordinator?

    // MARK: - Lifecycle
    public override func viewDidLoad() {
        super.viewDidLoad()
        title = "Transfers list"
        setupTableView()
        viewModel?.loadTransfers()
    }

    // MARK: - Private Methods
    private func setupTableView() {
        transferTableView.register(UINib(nibName: "TransferCell", bundle: .module), forCellReuseIdentifier: "TransferCell")
        transferTableView.dataSource = self
        transferTableView.delegate = self
        transferTableView.rowHeight = 100
        transferTableView.tableFooterView = UIView()
    }
}

// MARK: - UITableViewDataSource & UITableViewDelegate
extension TransferListViewController: UITableViewDataSource, UITableViewDelegate {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel?.transfers.count ?? 0
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "TransferCell", for: indexPath) as? TransferCell, let transfer = viewModel?.transfers[safe: indexPath.row] else { return UITableViewCell() }
        cell.configCell(data: transfer)
        return cell
    }

    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let transfer = viewModel?.transfers[safe: indexPath.row] else { return }
        // Example navigation: router?.route(to: .transferDetail(transfer))
        print("Selected transfer: \(transfer.name)")
    }
}

// MARK: - TransferListDelegate
extension TransferListViewController: TransferListDelegate {
    func didGetTransfers() {
        transferTableView.reloadData()
    }

    func getTransfersError(_ message: String) {
        let alert = UIAlertController(title: NSLocalizedString("Error", comment: "Error alert title"), message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "OK button"), style: .default))
        present(alert, animated: true)
    }
}

//TODO: Change loc this
// MARK: - Safe Array Access Helper
private extension Array {
    subscript(safe index: Int) -> Element? {
        indices.contains(index) ? self[index] : nil
    }
}

//TODO: Change loc this
public extension Bundle {
    static var transferFeature: Bundle {
        return .module
    }
}
