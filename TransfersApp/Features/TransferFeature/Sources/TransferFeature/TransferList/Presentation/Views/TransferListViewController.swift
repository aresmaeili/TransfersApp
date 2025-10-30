//
//  TransferListViewController.swift
//  TransfersApp
//
//  Created by AREM on 10/30/25.
//

import UIKit
import NetworkCore
import RouterCore

public final class TransferListViewController: UIViewController, UISearchResultsUpdating {

    // MARK: - Outlets
    @IBOutlet private weak var transferTableView: UITableView!
    private let searchController = UISearchController(searchResultsController: nil)

    // MARK: - Properties
    var viewModel: TransferListViewModel?
    var router: Coordinator?

    // MARK: - Lifecycle
    public override func viewDidLoad() {
        super.viewDidLoad()
        title = "Transfers List"
        setupTableView()
        setupSearchController()
        viewModel?.loadTransfers()
    }

    // MARK: - Private Methods

    private func setupSearchController() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.hidesNavigationBarDuringPresentation = false
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = true
        definesPresentationContext = true
    }

    private func setupTableView() {
        transferTableView.register(UINib(nibName: "TransferCell", bundle: .module), forCellReuseIdentifier: "TransferCell")
        transferTableView.register(UINib(nibName: "FavoriteTableViewCell", bundle: .module), forCellReuseIdentifier: "FavoriteTableViewCell")
        transferTableView.dataSource = self
        transferTableView.delegate = self
        transferTableView.rowHeight = 100
        transferTableView.tableFooterView = nil
    }

    @objc private func sortButtonTapped() {
        let alert = UIAlertController(
            title: "Sort Transfers",
            message: "Choose a sorting option",
            preferredStyle: .actionSheet
        )
        alert.addAction(UIAlertAction(title: NSLocalizedString("Name Ascending", comment: "Sort option"), style: .default) { _ in
            self.viewModel?.sortOption = .nameAscending
        })
        alert.addAction(UIAlertAction(title: NSLocalizedString("Name Descending", comment: "Sort option"), style: .default) { _ in
            self.viewModel?.sortOption = .nameDescending
        })
        alert.addAction(UIAlertAction(title: NSLocalizedString("Date Ascending", comment: "Sort option"), style: .default) { _ in
            self.viewModel?.sortOption = .dateAscending
        })
        alert.addAction(UIAlertAction(title: NSLocalizedString("Date Descending", comment: "Sort option"), style: .default) { _ in
            self.viewModel?.sortOption = .dateDescending
        })
        alert.addAction(UIAlertAction(title: NSLocalizedString("Amount Ascending", comment: "Sort option"), style: .default) { _ in
            self.viewModel?.sortOption = .amountAscending
        })
        alert.addAction(UIAlertAction(title: NSLocalizedString("Amount Descending", comment: "Sort option"), style: .default) { _ in
            self.viewModel?.sortOption = .amountDescending
        })
        alert.addAction(UIAlertAction(title: NSLocalizedString("Cancel", comment: "Cancel button"), style: .destructive))
        present(alert, animated: true)
    }

    // Helper to create section header views with optional sort button
    private func makeSectionHeader(title: String, hasSortButton: Bool) -> UIView {
        let headerView = UIView()
        headerView.backgroundColor = .systemBackground

        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .preferredFont(forTextStyle: .headline)
        label.textColor = .label
        label.textAlignment = .left
        label.text = title
        headerView.addSubview(label)

        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 16),
            label.topAnchor.constraint(equalTo: headerView.topAnchor, constant: 8),
            label.bottomAnchor.constraint(equalTo: headerView.bottomAnchor, constant: -8)
        ])

        if hasSortButton {
            let sortButton = UIButton(type: .system)
            sortButton.translatesAutoresizingMaskIntoConstraints = false
            sortButton.setTitle("Sort: \(viewModel?.sortOption.rawValue ?? "")", for: .normal)
            sortButton.addTarget(self, action: #selector(sortButtonTapped), for: .touchUpInside)
            headerView.addSubview(sortButton)

            NSLayoutConstraint.activate([
                sortButton.trailingAnchor.constraint(equalTo: headerView.trailingAnchor, constant: -16),
                sortButton.centerYAnchor.constraint(equalTo: label.centerYAnchor),
                label.trailingAnchor.constraint(lessThanOrEqualTo: sortButton.leadingAnchor, constant: -8)
            ])
        } else {
            NSLayoutConstraint.activate([
                label.trailingAnchor.constraint(equalTo: headerView.trailingAnchor, constant: -16)
            ])
        }

        return headerView
    }

    // Computed property for number of sections
    private var numberOfSections: Int {
        return 2
    }

    // MARK: - UISearchResultsUpdating
    public func updateSearchResults(for searchController: UISearchController) {
        let text = searchController.searchBar.text ?? ""
        viewModel?.textSearch = text
    }
}

// MARK: - UITableViewDataSource & UITableViewDelegate
extension TransferListViewController: UITableViewDataSource, UITableViewDelegate {
    public func numberOfSections(in tableView: UITableView) -> Int {
        return numberOfSections
    }

    public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        switch section {
        case 0:
            return makeSectionHeader(title: "Favorites:", hasSortButton: false)
        case 1:
            return makeSectionHeader(title: "Transfers:", hasSortButton: true)
        default:
            return nil
        }
    }

    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            return viewModel?.filteredTransfers?.count ?? 0
        default:
            return 0
        }
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "FavoriteTableViewCell", for: indexPath) as? FavoriteTableViewCell else {
                return UITableViewCell()
            }
            cell.configure(with: viewModel?.favoritesTranfers.reversed() ?? [] )
            return cell
        } else {
            guard
                let cell = tableView.dequeueReusableCell(withIdentifier: "TransferCell", for: indexPath) as? TransferCell,
                let transfer = viewModel?.filteredTransfers?[safe: indexPath.row]
            else {
                return UITableViewCell()
            }
            cell.configCell(data: transfer)
            return cell
        }
    }

    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0:
            return 150
        default:
            return 80
        }
    }

    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard indexPath.section == 1, let transfer = viewModel?.filteredTransfers?[safe: indexPath.row] else { return }
        // Example navigation: router?.route(to: .transferDetail(transfer))
        print("Selected transfer: \(transfer.name)")
        viewModel?.favoritesTranfers.append(transfer)
        tableView.reloadSections([0], with: .none)
    }
}

// MARK: - TransferListDelegate
extension TransferListViewController: TransferListDelegate {
    func didGetTransfers() {
        transferTableView.reloadData()
    }

    func getTransfersError(_ message: String) {
        let alert = UIAlertController(
            title: "Error",
            message: message,
            preferredStyle: .alert
        )
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
