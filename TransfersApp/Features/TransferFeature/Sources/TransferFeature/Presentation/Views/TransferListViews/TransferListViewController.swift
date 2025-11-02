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
        var viewModel: TransferListViewModelProtocol?
    
    // UI Components
    @IBOutlet private weak var transferTableView: UITableView!
    private let refreshControl = UIRefreshControl()
    
    private lazy var searchController: UISearchController = {
        let controller = UISearchController(searchResultsController: nil)
        controller.searchResultsUpdater = self
        controller.obscuresBackgroundDuringPresentation = false
        controller.hidesNavigationBarDuringPresentation = true
        return controller
    }()
    
    // MARK: - Lifecycle
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let _ = viewModel else {
            fatalError("ViewModel must be injected.")
        }
        
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
        print("TransferList deinit")
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
            self?.setLoading(isLoading)
        }
    }
}

// MARK: - UISearchResultsUpdating
extension TransferListViewController: UISearchResultsUpdating {
    public func updateSearchResults(for searchController: UISearchController) {
        let searchText = searchController.searchBar.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        viewModel?.changedTextSearch(with: searchText)
    }
}

// MARK: - UITableViewDataSource
extension TransferListViewController: UITableViewDataSource {
    
    public func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel?.hasFavoriteRow == true ? 2 : 1
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let viewModel = viewModel else { return 0 }
        
        switch section {
        case 0:
            return viewModel.hasFavoriteRow ? 1 : 0
        case 1:
            return viewModel.transfersCount
        default:
            return 0
        }
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
        guard let viewModel = viewModel else { return 0 }
        
        switch indexPath.section {
        case 0:
            return viewModel.hasFavoriteRow ? 150 : 0
        case 1:
            return 80
        default:
            return 0
        }
    }
    
    public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let viewModel = viewModel else { return nil }
        
        switch section {
        case 0:
            return viewModel.hasFavoriteRow ? makeSectionHeader(title: "Favorites:", showEditButton: true, isTransfersSection: false) : nil
        case 1:
            return makeSectionHeader(title: "Transfers:", showSortButton: true, isTransfersSection: true)
        default:
            return nil
        }
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        switch indexPath.section {
        case 1:
            guard let transfer = viewModel?.getTransferItem(at: indexPath.row) else { return }
            viewModel?.routeToDetails(for: transfer)
        default:
            return
        }
        
    }
    
    public func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard indexPath.section == 1, let itemViewModel = viewModel?.getTransferItem(at: indexPath.row) else { return }
        viewModel?.loadNextPageIfNeeded(currentItem: itemViewModel)
    }
    
//    func sectionTitle(section: Int) -> (String, String) {
//        switch section {
//        case 0:
//            return ("Favorites:", viewModel?.canEdit ?? false ? "Done" : "Edit")
//        case 1:
//            return ("Transfers:", "Sort: \(viewModel?.sortOption.rawValue ?? "-")")
//        default:
//            return ("", "")
//        }
}

// MARK: - Cell Creation & Configuration Helpers
private extension TransferListViewController {
    
    func createFavoriteCell(for tableView: UITableView) -> UITableViewCell {
        guard let cell = tableView.dequeueCell(FavoriteTableViewCell.self),
              let viewModel = viewModel else {
            assertionFailure("Could not dequeue FavoriteTableViewCell")
            return UITableViewCell()
        }
        
        cell.configure(with: viewModel)
        return cell
    }
    
    func createTransferCell(for tableView: UITableView, at indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueCell(TransferCell.self), let transfer = viewModel?.getTransferItem(at: indexPath.row) else { return UITableViewCell() }
        let isFavorite = viewModel?.checkIsFavorite(transfer) ?? false
        cell.configCell(data: transfer, isFavorite: isFavorite)
        return cell
    }
}

// MARK: - Section Header & Actions
private extension TransferListViewController {
    
    func makeSectionHeader(title: String, showEditButton: Bool = false, showSortButton: Bool = false, isTransfersSection: Bool) -> UIView {
        // 💡 Simplify header creation by only passing necessary data
        let headerView = UIView()
        headerView.backgroundColor = .systemBackground
        
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .preferredFont(forTextStyle: .headline)
        label.text = title
        headerView.addSubview(label)
        
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 16),
            label.centerYAnchor.constraint(equalTo: headerView.centerYAnchor)
        ])
        
        if showSortButton {
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
        }
        
        // 💡 Edit Button (only for Favorites section)
        if showEditButton {
             let editButton = UIButton(type: .system)
             editButton.translatesAutoresizingMaskIntoConstraints = false
             let buttonTitle = viewModel?.canEdit == true ? "Done" : "Edit"
             editButton.setTitle(buttonTitle, for: .normal)
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
        
        // 💡 فرض می‌کنیم SortOption.allCases تعریف شده است.
        for sort in SortOption.allCases {
            alert.addAction(UIAlertAction(title: sort.rawValue, style: .default) { [weak self] _ in
                self?.viewModel?.sortOption = sort // 💡 ارسال Input به ViewModel
            })
        }
        
        alert.addAction(UIAlertAction(title:"Cancel", style: .cancel))
        present(alert, animated: true)
    }
    
    @objc func editButtonTapped() {
        // 💡 فرض می‌کنیم متد toggleCanEdit به ViewModel اضافه شده است.
        viewModel?.toggleCanEdit()
        transferTableView.reloadData()
    }
}
