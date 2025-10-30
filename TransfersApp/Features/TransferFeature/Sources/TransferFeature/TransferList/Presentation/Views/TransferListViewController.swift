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
        title = NSLocalizedString("Transfers List", comment: "Title for the transfers list screen")
        setupTableView()
        viewModel?.loadTransfers()
    }

    // MARK: - Private Methods
    private func setupTableView() {
        transferTableView.register(UINib(nibName: "TransferCell", bundle: .module), forCellReuseIdentifier: "TransferCell")
        transferTableView.register(UINib(nibName: "FavoriteTableViewCell", bundle: .module), forCellReuseIdentifier: "FavoriteTableViewCell")
        transferTableView.dataSource = self
        transferTableView.delegate = self
        transferTableView.rowHeight = 100
        transferTableView.tableFooterView = nil
    }
}

// MARK: - UITableViewDataSource & UITableViewDelegate
extension TransferListViewController: UITableViewDataSource, UITableViewDelegate {
    public func numberOfSections(in tableView: UITableView) -> Int {
        2
    }

    public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = .systemBackground

        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .preferredFont(forTextStyle: .headline)
        label.textColor = .label
        label.textAlignment = .left
        label.text = section == 0 ? "Favorites:" : "Transfers:"
        headerView.addSubview(label)
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 16),
            label.trailingAnchor.constraint(equalTo: headerView.trailingAnchor, constant: -16),
            label.topAnchor.constraint(equalTo: headerView.topAnchor, constant: 8),
            label.bottomAnchor.constraint(equalTo: headerView.bottomAnchor, constant: -8)
        ])
        return headerView
    }

    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
            case 0: return 1
            case 1: return viewModel?.transfers.count ?? 0
            default: return 0
        }
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
            case 0:
                guard let cell = tableView.dequeueReusableCell(withIdentifier: "FavoriteTableViewCell", for: indexPath) as? FavoriteTableViewCell else { return UITableViewCell() }
                cell.configure(with: [])
                return cell
            default:
                guard let cell = tableView.dequeueReusableCell(withIdentifier: "TransferCell", for: indexPath) as? TransferCell,
                      let transfer = viewModel?.transfers[safe: indexPath.row] else { return UITableViewCell() }
                cell.configCell(data: transfer)
                return cell
        }
    }

    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
            case 0: return 150
            default: return 80
        }
    }

    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard indexPath.section == 1, let transfer = viewModel?.transfers[safe: indexPath.row] else { return }
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

// TODO: Move safe array access helper and Bundle extension to separate files for better organization
private extension Array {
    subscript(safe index: Int) -> Element? {
        indices.contains(index) ? self[index] : nil
    }
}

public extension Bundle {
    static var transferFeature: Bundle {
        return .module
    }
}

