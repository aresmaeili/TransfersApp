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
    // MARK: - Properties
    
    // Dependencies
    var viewModel: TransferListViewModel?
    
    // UI Components
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
        
        // Setup methods
        configureView()
        setupTableView()
        setupSearchController()
        bindViewModel()
        
        // Initial data load
        viewModel?.refreshTransfers()
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        transferTableView.reloadData()
    }
    
    deinit {
        print("TransferLIst deinit" )
    }
}

// MARK: - Configuration & Binding (MVVM Communication)
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
//        transferTableView.prefetchDataSource = self
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
        
        viewModel?.onUpdate = { [weak self] in
            guard let self = self else { return }
            self.refreshControl.endRefreshing()
            self.transferTableView.reloadData()
        }
        
        viewModel?.onErrorOccurred = { [weak self] message in
            self?.showErrorAlert(title: "Error", message: message)
        }
        
        viewModel?.onLoadingStateChange = { [weak self] isLoading in
            self?.setLoading(isLoading) // فرض می‌کنیم setLoading یک متد کمکی در Shared/BaseVC است.
        }
    }
}

// MARK: - UISearchResultsUpdating
extension TransferListViewController: UISearchResultsUpdating {
    public func updateSearchResults(for searchController: UISearchController) {
        let searchText = searchController.searchBar.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        if searchText != viewModel?.textSearch {
            viewModel?.textSearch = searchText // ارسال ورودی کاربر به ViewModel
        }
    }
}

// MARK: - UITableViewDataSource
extension TransferListViewController: UITableViewDataSource {
    
    public func numberOfSections(in tableView: UITableView) -> Int {
        numberOfSections
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
    var numberOfSections: Int {
        return 2
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0:
            return viewModel?.hasFavoriteRow ?? false ? 150 : 0
        case 1:
            return 80
        default:
            return 0
        }
    }
    
    public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let hasFavorites = viewModel?.hasFavoriteRow ?? false
        
        let title = sectionTitle(section: section)
        let header = makeSectionHeader(title: title.0, hasSortButton: false)
        guard section == 0 else {
            return makeSectionHeader(title: title.0, hasSortButton: true)
        }
        return hasFavorites ? header : nil
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard indexPath.section == 1, let transfer = viewModel?.getTransferItem(at: indexPath.row) else { return }
        viewModel?.routeToDetails(for: transfer)
    }
    
    public func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard indexPath.section == 1, let currentItem = viewModel?.getTransferItem(at: indexPath.row) else { return }
        viewModel?.loadNextPageIfNeeded(currentItem: currentItem)
    }
    
    func sectionTitle(section: Int) -> (String, String) {
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

// MARK: - Cell Creation & Configuration Helpers
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

//// MARK: - Cell Creation & Configuration Helpers
//private extension TransferListViewController {
//    
//    func createFavoriteCell(for tableView: UITableView) -> UITableViewCell {
//        guard let cell = tableView.dequeueCell(FavoriteTableViewCell.self), let viewModel else {
//            assertionFailure("Could not dequeue FavoriteTableViewCell")
//            return UITableViewCell()
//        }
//        
//        cell.configure(with: viewModel)
//        return cell
//    }
//    
//    func createTransferCell(for tableView: UITableView, at indexPath: IndexPath) -> UITableViewCell {
//        guard let cell = tableView.dequeueCell(TransferCell.self),
//              let transfer = viewModel?.getTransfer(at: indexPath.row) else {
//            assertionFailure("Could not dequeue TransferCell or get transfer data")
//            return UITableViewCell()
//        }
//        let isFavorite = viewModel?.checkIfTransferIsFavorite(transfer: transfer) ?? false
//        cell.configCell(data: transfer, isFavorite: isFavorite)
//        return cell
//    }
//}

// MARK: - Section Header & Sort Logic
private extension TransferListViewController {
    
    func makeSectionHeader(title: String, hasSortButton: Bool) -> UIView {
        let headerView = UIView()
        headerView.backgroundColor = .background3
        
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
            sortButton.setTitle("Sort: \(viewModel?.sortOption.displayName ?? "-")", for: .normal)
            sortButton.addTarget(self, action: #selector(sortButtonTapped), for: .touchUpInside)
            headerView.addSubview(sortButton)
            
            NSLayoutConstraint.activate([
                sortButton.trailingAnchor.constraint(equalTo: headerView.trailingAnchor, constant: -16),
                sortButton.centerYAnchor.constraint(equalTo: label.centerYAnchor),
                label.trailingAnchor.constraint(lessThanOrEqualTo: sortButton.leadingAnchor, constant: -8)
            ])
        } else {
            let editButton = UIButton(type: .system)
            editButton.translatesAutoresizingMaskIntoConstraints = false
            let title = viewModel?.canEdit == true ? "Done" : "Edit"
            editButton.setTitle(title, for: .normal)
            editButton.addTarget(self, action: #selector(editButtonTapped), for: .touchUpInside)
            headerView.addSubview(editButton)

            NSLayoutConstraint.activate([
                editButton.trailingAnchor.constraint(equalTo: headerView.trailingAnchor, constant: -16),
                editButton.centerYAnchor.constraint(equalTo: label.centerYAnchor),
                label.trailingAnchor.constraint(lessThanOrEqualTo: editButton.leadingAnchor, constant: -8)
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
        
        for sort in SortOption.allCases {
            alert.addAction(UIAlertAction(title: sort.displayName, style: .default) { [weak self] _ in
                guard let self else { return }
                self.viewModel?.sortOption = sort
            })
        }
        
        alert.addAction(UIAlertAction(title:"Cancel", style: .destructive))
        present(alert, animated: true)
    }
    
    @objc func editButtonTapped() {
        viewModel?.toggleCanEdit()
        transferTableView.reloadData()
    }
}
