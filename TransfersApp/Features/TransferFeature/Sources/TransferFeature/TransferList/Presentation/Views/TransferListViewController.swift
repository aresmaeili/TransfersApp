//
//  TransferListViewController.swift
//  TransfersApp
//
//  Created by AREM on 10/30/25.
//
import UIKit
import NetworkCore
import RouterCore
import Shared

public final class TransferListViewController: UIViewController {
    // MARK: - Properties
    
    // Dependencies
    var viewModel: TransferListViewModel?
    weak var router: Coordinator?
    
    // UI Components
    @IBOutlet private weak var transferTableView: UITableView!
    private let refreshControl = UIRefreshControl()
    private lazy var searchController: UISearchController = {
        let controller = UISearchController(searchResultsController: nil)
        controller.searchResultsUpdater = self
        controller.obscuresBackgroundDuringPresentation = false
        controller.hidesNavigationBarDuringPresentation = false
        return controller
    }()
    
    // MARK: - Lifecycle
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setup methods
        configureView()
        setupTableView()
        setupSearchController()
        // Initial data load
        viewModel?.refreshTransfers()
    }
}

// MARK: - TransferListDisplay (ViewModel Communication)
extension TransferListViewController: TransferListDisplay {
    func didUpdateTransfers() {
        self.refreshControl.endRefreshing()
        self.transferTableView.reloadSections([1], with: .automatic)
    }

    func displayError(_ message: String) {
            self.showErrorAlert(title: "Error", message: message)
    }
}

// MARK: - Configuration
private extension TransferListViewController {
    func configureView() {
        title = "Transfers List"
        viewModel?.delegate = self
        transferTableView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
    }

    /// Configures the UITableView.
    func setupTableView() {
        transferTableView.registerCell(TransferCell.self, module: .module)
        transferTableView.registerCell(FavoriteTableViewCell.self, module: .module)
        transferTableView.dataSource = self
        transferTableView.delegate = self
    }
    
    /// Configures the UISearchController.
    func setupSearchController() {
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = true
        definesPresentationContext = true
    }
    
    @objc func handleRefresh() {
        // Ask ViewModel to refresh first page. Implement this method in ViewModel accordingly.
        viewModel?.refreshTransfers()
    }
}

// MARK: - UISearchResultsUpdating
extension TransferListViewController: UISearchResultsUpdating {
    public func updateSearchResults(for searchController: UISearchController) {
        let searchText = searchController.searchBar.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        if searchText != viewModel?.textSearch {
            viewModel?.textSearch = searchText
        }
    }
}

// MARK: - UITableViewDataSource
extension TransferListViewController: UITableViewDataSource {
    
    public func numberOfSections(in tableView: UITableView) -> Int {
        numberOfSections
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel?.numberOfRows(section: section) ?? 0
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            return createFavoriteCell(for: tableView)
        case 1:
            return createTransferCell(for: tableView, at: indexPath)
        default:
            return UITableViewCell()
        }
    }
}

// MARK: - UITableViewDelegate
extension TransferListViewController: UITableViewDelegate {
    var numberOfSections: Int {
        return 2
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0:
            return 150
        case 1:
            return 80
        default:
            return 0
        }
    }
    
    public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let title = sectionTitle(section: section)
        // Only show sort button for the main transfer list section (e.g., section 1)
        let hasSortButton = section == 1
        return makeSectionHeader(title: title, hasSortButton: hasSortButton)
    }

    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard indexPath.section == 1,
        let transfer = viewModel?.getTransfer(at: indexPath.row) else { return }
        viewModel?.addTransfersToFavorite(transfer: transfer)
        tableView.reloadSections([0], with: .automatic)
    }
    
    public func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard indexPath.section == 1, let currentItem = viewModel?.getTransfer(at: indexPath.row) else { return }
        viewModel?.loadNextPageIfNeeded(currentItem: currentItem)
    }
    
    func sectionTitle(section: Int) -> String {
        switch section {
        case 0:
            return "Favorites:"
        case 1:
            return "Transfers:"
        default:
            return ""
        }
    }
}

// MARK: - Cell Creation & Configuration Helpers
private extension TransferListViewController {
    
    func createFavoriteCell(for tableView: UITableView) -> UITableViewCell {
        guard let cell = tableView.dequeueCell(FavoriteTableViewCell.self), let favorites = viewModel?.getFavorites() else {
            assertionFailure("Could not dequeue FavoriteTableViewCell")
            return UITableViewCell()
        }
        
        cell.configure(with: favorites)
        return cell
    }
    
    func createTransferCell(for tableView: UITableView, at indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueCell(TransferCell.self),
              let transfer = viewModel?.getTransfer(at: indexPath.row) else {
            assertionFailure("Could not dequeue TransferCell or get transfer data")
            return UITableViewCell()
        }
        cell.configCell(data: transfer)
        return cell
    }
}

// MARK: - Section Header & Sort Logic
private extension TransferListViewController {
    
    func makeSectionHeader(title: String, hasSortButton: Bool) -> UIView {
        let headerView = UIView()
        headerView.backgroundColor = .systemBackground
        
        // --- Label Setup ---
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
        
        // --- Sort Button Setup (Conditional) ---
        if hasSortButton {
            let sortButton = UIButton(type: .system)
            sortButton.translatesAutoresizingMaskIntoConstraints = false
            sortButton.setTitle("Sort: \(viewModel?.sortOption.rawValue ?? "-")", for: .normal)
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

    @objc func sortButtonTapped() {
        guard let _ = viewModel?.sortOption else { return }

        let alert = UIAlertController(
            title: "Sort Transfers",
            message: "Choose a sorting option",
            preferredStyle: .actionSheet
        )
        alert.addAction(UIAlertAction(title: "Name Ascending", style: .default) { _ in
            self.viewModel?.sortOption = .nameAscending
        })
        alert.addAction(UIAlertAction(title: "Name Descending", style: .default) { _ in
            self.viewModel?.sortOption = .nameDescending
        })
        alert.addAction(UIAlertAction(title: "Date Ascending", style: .default) { _ in
            self.viewModel?.sortOption = .dateAscending
        })
        alert.addAction(UIAlertAction(title: "Date Descending", style: .default) { _ in
            self.viewModel?.sortOption = .dateDescending
        })
        alert.addAction(UIAlertAction(title: "Amount Ascending", style: .default) { _ in
            self.viewModel?.sortOption = .amountAscending
        })
        alert.addAction(UIAlertAction(title: "Amount Descending", style: .default) { _ in
            self.viewModel?.sortOption = .amountDescending
        })
        alert.addAction(UIAlertAction(title:"Cancel", style: .destructive))
        present(alert, animated: true)
    }
}
