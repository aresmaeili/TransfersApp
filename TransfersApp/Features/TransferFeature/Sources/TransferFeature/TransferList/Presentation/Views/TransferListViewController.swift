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
        transferTableView.registerCell(TransferCell.self)
        transferTableView.registerCell(FavoriteTableViewCell.self)
        transferTableView.dataSource = self
        transferTableView.delegate = self
    }

 
    // MARK: - UISearchResultsUpdating
    public func updateSearchResults(for searchController: UISearchController) {
        let text = searchController.searchBar.text ?? ""
        viewModel?.textSearch = text
    }
}

// MARK: - UITableViewDataSource & UITableViewDelegate
extension TransferListViewController: UITableViewDataSource {
    public func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel?.numberOfSections ?? 0
    }

    public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let title = viewModel?.getSectionTitle(section: section) ?? ""
        return makeSectionHeader(title: title, hasSortButton: false)
    }

    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return viewModel?.sectionCount(section: section) ?? 0
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            return createFavoriteCell(tableView: tableView)
        } else {
            return createListCell(tableView: tableView, indexPath: indexPath)
        }
    }
    
    func createFavoriteCell(tableView: UITableView) -> UITableViewCell {
        guard let cell = tableView.dequeueCell(FavoriteTableViewCell.self) else { return UITableViewCell() }
        cell.configure(with: viewModel?.favoritesTranfersReversed ?? [])
        return cell
    }
    
    func createListCell(tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueCell(TransferCell.self), let transfer = viewModel?.getTransfer(at: indexPath.row) else { return UITableViewCell() }
        cell.configCell(data: transfer)
        return cell
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
}

extension TransferListViewController: UITableViewDelegate {
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        getHeightForRow(at: indexPath)
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard indexPath.section == 1, let transfer = viewModel?.getTransfer(at: indexPath.row) else { return }
        // Example navigation: router?.route(to: .transferDetail(transfer))
        viewModel?.addTransfersToFavorite(transfer: transfer)
        tableView.reloadSections([0], with: .none)
    }
    
    func getHeightForRow(at indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0:
            return 150
        default:
            return 80
        }
    }
}

extension TransferListViewController {
    @objc private func sortButtonTapped() {
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

// MARK: - TransferListDelegate
extension TransferListViewController: TransferListDelegate {
    func didGetTransfers() {
        transferTableView.reloadData()
    }

    func getTransfersError(_ message: String) {
      showErrorAlert(title: "Error", message: message)
    }
}





extension UIViewController {
    func showErrorAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}

// TODO: Move safe array access helper and Bundle extension to separate files for better organization
extension Array {
    subscript(safe index: Int) -> Element? {
        indices.contains(index) ? self[index] : nil
    }
}

public extension Bundle {
    static var transferFeature: Bundle {
        return .module
    }
}

import UIKit

extension UITableView {
    func registerCell<T: UITableViewCell>(_ cell: T.Type) {
        self.register(UINib(nibName: String(describing: cell), bundle: .module), forCellReuseIdentifier: String(describing: cell))
    }
}

extension UITableView {
    func dequeueCell<T: UITableViewCell>(_ cell: T.Type) -> T? {
        guard let cell = self.dequeueReusableCell(withIdentifier: String(describing: cell)) as? T else { return nil }
        cell.selectionStyle = .none
        return cell
    }
}

extension UICollectionView {
    func registerCell<T: UICollectionViewCell>(_ cell: T.Type) {
        self.register(UINib(nibName: String(describing: cell), bundle: .module), forCellWithReuseIdentifier: String(describing: cell))
    }
}

extension UICollectionView {
    func dequeueCell<T: UICollectionViewCell>(_ cell: T.Type, indexPath: IndexPath) -> T {
        let cell = self.dequeueReusableCell(withReuseIdentifier: String(describing: cell), for: indexPath) as! T
        return cell
    }
}
