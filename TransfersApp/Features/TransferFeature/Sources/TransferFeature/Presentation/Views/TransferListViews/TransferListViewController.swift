//
//  TransferListViewController.swift
//  TransfersApp
//
//  Created by AREM on 10/30/25.
//

import UIKit
import RouterCore
import Shared

public final class TransferListViewController: UIViewController {
    
    // MARK: - Dependencies
    var viewModel: TransferListViewModel?
    
    // MARK: - UI Components
    @IBOutlet private weak var transferTableView: UITableView!
    private let refreshControl = UIRefreshControl()
    
    private lazy var searchController: UISearchController = {
        let controller = UISearchController(searchResultsController: nil)
        controller.searchResultsUpdater = self
        controller.obscuresBackgroundDuringPresentation = true
        controller.hidesNavigationBarDuringPresentation = true
        return controller
    }()
    
    // MARK: - Lifecycle
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        setupTableView()
        setupSearchController()
        bindViewModel()
        viewModel?.refreshTransfers()
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        transferTableView.reloadData()
    }
    
    deinit {
        print("🧹 Deinit: TransferListViewController")
    }
}

// MARK: - Configuration & Binding
private extension TransferListViewController {
    
    func configureView() {
        title = "Transfers List"
        transferTableView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
    }
    
    func setupTableView() {
        transferTableView.registerCell(TransferCell.self, module: .module)
        transferTableView.registerCell(FavoriteTableViewCell.self, module: .module)
        transferTableView.dataSource = self
        transferTableView.delegate = self
        transferTableView.backgroundColor = .background3
    }
    
    func setupSearchController() {
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = true
        definesPresentationContext = true
    }
    
    @objc func handleRefresh() {
        viewModel?.refreshTransfers()
    }
    
    private func bindViewModel() {
        guard let viewModel else { return }

        viewModel.onUpdate = { [weak self] in
            guard let self = self else { return }
            self.refreshControl.endRefreshing()
            self.transferTableView.reloadData()
        }
        
        viewModel.onErrorOccurred = { [weak self] message in
            self?.showErrorAlert(title: "Error", message: message)
        }
        
        viewModel.onLoadingStateChange = { [weak self] isLoading in
            self?.setLoading(isLoading)
        }
    }
}

// MARK: - UISearchResultsUpdating
extension TransferListViewController: UISearchResultsUpdating {
    public func updateSearchResults(for searchController: UISearchController) {
        let searchText = searchController.searchBar.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        if searchText != viewModel?.textSearch {
            viewModel?.changedTextSearch(with: searchText)
        }
    }
}

// MARK: - UITableViewDataSource
extension TransferListViewController: UITableViewDataSource {
    
    public func numberOfSections(in tableView: UITableView) -> Int {
        2
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel?.numberOfRows(in: section) ?? 0
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
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0:
            return (viewModel?.hasFavoriteRow ?? false) ? 200 : 0
        case 1:
            return 120
        default:
            return 0
        }
    }
    
    public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let viewModel else { return nil }
        
        let title = sectionTitle(for: section)
        let hasFavorites = viewModel.hasFavoriteRow
        
        // Section 0: "Favorites" (with Edit/Done)
        if section == 0 {
            return hasFavorites ? makeSectionHeader(title: title.title, isFavorites: true) : nil
        }
        
        // Section 1: "Transfers" (with Sort button)
        return makeSectionHeader(title: title.title, isFavorites: false)
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard indexPath.section == 1, let transfer = viewModel?.getTransferItem(at: indexPath.row) else { return }
        viewModel?.routeToDetails(for: transfer)
    }
    
    public func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard indexPath.section == 1, let currentItem = viewModel?.getTransferItem(at: indexPath.row) else { return }
        viewModel?.loadNextPageIfNeeded(currentItem: currentItem)
    }
    
    private func sectionTitle(for section: Int) -> (title: String, actionTitle: String) {
        switch section {
        case 0:
            return ("Favorites:", viewModel?.canEdit ?? false ? "Done" : "Edit")
        case 1:
            return ("Transfers:", "Sort: \(viewModel?.sortOption.displayName ?? "-")")
        default:
            return ("", "")
        }
    }
}

// MARK: - Cell Creation

private extension TransferListViewController {
    
    func createFavoriteCell(for tableView: UITableView) -> UITableViewCell {
        guard let cell = tableView.dequeueCell(FavoriteTableViewCell.self), let viewModel else {
            assertionFailure("Could not dequeue FavoriteTableViewCell")
            return UITableViewCell()
        }
        
        cell.configure(with: viewModel)
        return cell
    }
    
    func createTransferCell(for tableView: UITableView, at indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueCell(TransferCell.self),
              let transfer = viewModel?.getTransferItem(at: indexPath.row) else {
            assertionFailure("Could not dequeue TransferCell or get transfer data")
            return UITableViewCell()
        }
        
        let isFavorite = viewModel?.checkIsFavorite(transfer) ?? false
        cell.configCell(data: transfer, isFavorite: isFavorite)
        return cell
    }
}

// MARK: - Section Header & Actions
private extension TransferListViewController {
    
    func makeSectionHeader(title: String, isFavorites: Bool) -> UIView {
        let header = UIView()
        header.backgroundColor = .background3
        
        let titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.font = .preferredFont(forTextStyle: .headline)
        titleLabel.textColor = .label
        titleLabel.text = title
        header.addSubview(titleLabel)
        
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        if isFavorites {
            let editTitle = viewModel?.canEdit == true ? "Done" : "Edit"
            button.setTitle(editTitle, for: .normal)
            button.addTarget(self, action: #selector(editButtonTapped), for: .touchUpInside)
        } else {
            button.setTitle("Sort: \(viewModel?.sortOption.displayName ?? "-")", for: .normal)
            button.addTarget(self, action: #selector(sortButtonTapped), for: .touchUpInside)
        }
        
        header.addSubview(button)
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: header.leadingAnchor, constant: 16),
            titleLabel.centerYAnchor.constraint(equalTo: header.centerYAnchor),
            
            button.trailingAnchor.constraint(equalTo: header.trailingAnchor, constant: -16),
            button.centerYAnchor.constraint(equalTo: header.centerYAnchor),
            
            titleLabel.trailingAnchor.constraint(lessThanOrEqualTo: button.leadingAnchor, constant: -8)
        ])
        
        return header
    }
    
    @objc func sortButtonTapped() {
        guard let _ = viewModel?.sortOption else { return }
        
        let alert = UIAlertController(
            title: "Sort Transfers",
            message: "Choose a sorting option",
            preferredStyle: .actionSheet
        )
        
        SortOption.allCases.forEach { sort in
            alert.addAction(UIAlertAction(title: sort.displayName, style: .default) { [weak self] _ in
                guard let self else { return }
                self.viewModel?.sortOption = sort
            })
        }
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(alert, animated: true)
    }
    
    @objc func editButtonTapped() {
        viewModel?.toggleCanEdit()
        transferTableView.reloadData()
    }
}
