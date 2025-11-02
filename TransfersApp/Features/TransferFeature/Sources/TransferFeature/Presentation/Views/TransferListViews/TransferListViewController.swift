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
        updateNavigationBarAppearance(for: traitCollection.userInterfaceStyle)
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        transferTableView.reloadData()
    }
    
    public override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        
        if previousTraitCollection?.userInterfaceStyle != traitCollection.userInterfaceStyle {
            updateNavigationBarAppearance(for: traitCollection.userInterfaceStyle)
        }
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
        transferTableView.contentInset = UIEdgeInsets(top: -10, left: 0, bottom: 0, right: 0)

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
    
    private func updateNavigationBarAppearance(for style: UIUserInterfaceStyle) {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .background3
        appearance.titleTextAttributes = [.foregroundColor: UIColor.text1]
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        navigationController?.navigationBar.compactAppearance = appearance
        navigationController?.navigationBar.tintColor = (style == .dark) ? .white : .black
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
        Section.allCases.count
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel?.numberOfRows(in: section) ?? 0
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let section = Section(rawValue: indexPath.section) else { return UITableViewCell() }
        switch section {
        case .favorites:
            return createFavoriteCell(for: tableView)
        case .transfers:
            return createTransferCell(for: tableView, at: indexPath)
        }
    }
}

// MARK: - UITableViewDelegate
extension TransferListViewController: UITableViewDelegate {
    
    // MARK: - Section Definition
    private enum Section: Int, CaseIterable {
        case favorites
        case transfers
        
        var height: CGFloat {
            switch self {
            case .favorites: return 160
            case .transfers: return 100
            }
        }
        
        var titlePrefix: String {
            switch self {
            case .favorites: return "Favorites:"
            case .transfers: return "Transfers:"
            }
        }
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let section = Section(rawValue: indexPath.section),
              let viewModel else { return 0 }

        switch section {
        case .favorites:
            return viewModel.hasFavoriteRow ? section.height : 0
        case .transfers:
            return section.height
        }
    }
    
    public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return shouldShowHeader(for: section) ? UITableView.automaticDimension : 0
    }
    
    public func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
        return shouldShowHeader(for: section) ? UITableView.automaticDimension : 0
    }
    
    public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let section = Section(rawValue: section), let viewModel else { return nil }
        let title = section.titlePrefix
        
        switch section {
        case .favorites:
            return viewModel.hasFavoriteRow ? makeSectionHeader(title: title, isFavorites: true) : nil
        case .transfers:
            return makeSectionHeader(title: title, isFavorites: false)
        }
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let section = Section(rawValue: indexPath.section), section == .transfers, let transfer = viewModel?.getTransferItem(at: indexPath.row) else { return }
        viewModel?.routeToDetails(for: transfer)
    }
    
    public func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let section = Section(rawValue: indexPath.section), section == .transfers, let currentItem = viewModel?.getTransferItem(at: indexPath.row) else { return }
        viewModel?.loadNextPageIfNeeded(currentItem: currentItem)
    }
    
    private func shouldShowHeader(for sectionIndex: Int) -> Bool {
        guard let section = Section(rawValue: sectionIndex), let viewModel else { return false }
        if section == .favorites { return viewModel.hasFavoriteRow }
        return true
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
        header.backgroundColor = .clear
        
        let titleLabel = UILabel()
        titleLabel.font = .preferredFont(forTextStyle: .headline)
        titleLabel.textColor = .label
        titleLabel.text = title
        
        let button = UIButton(type: .system)
        configureHeaderButton(button, isFavorites: isFavorites)
        
        [titleLabel, button].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            header.addSubview($0)
        }
        
        let padding: CGFloat = 16
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: header.leadingAnchor, constant: padding),
            titleLabel.centerYAnchor.constraint(equalTo: header.centerYAnchor, constant: -5),
            
            button.trailingAnchor.constraint(equalTo: header.trailingAnchor, constant: -padding),
            button.centerYAnchor.constraint(equalTo: header.centerYAnchor, constant: -5),
            button.leadingAnchor.constraint(greaterThanOrEqualTo: titleLabel.trailingAnchor, constant: 8)
        ])
        
        return header
    }
    
    func configureHeaderButton(_ button: UIButton, isFavorites: Bool) {
        if isFavorites {
            let editTitle = viewModel?.canEdit == true ? "Done" : "Edit"
            button.setTitle(editTitle, for: .normal)
            button.addTarget(self, action: #selector(editButtonTapped), for: .touchUpInside)
        } else {
            let sortTitle = "Sort: \(viewModel?.sortOption.displayName ?? "-")"
            button.setTitle(sortTitle, for: .normal)
            button.addTarget(self, action: #selector(sortButtonTapped), for: .touchUpInside)
        }
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
