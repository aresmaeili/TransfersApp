//
//  TransferListViewController.swift
//  TransfersApp
//
//  Created by AREM on 10/30/25.
//
//

import UIKit
import Shared
import Combine

public final class TransferListViewController: UIViewController {

    // MARK: - Dependencies
    var viewModel: TransfersViewModelInputProtocol?

    // MARK: - UI
    @IBOutlet private weak var transferTableView: UITableView!
    private let refreshControl = UIRefreshControl()

    private lazy var searchController: UISearchController = {
        let controller = UISearchController(searchResultsController: nil)
        controller.searchResultsUpdater = self
        controller.obscuresBackgroundDuringPresentation = false
        controller.hidesNavigationBarDuringPresentation = true
        return controller
    }()

    // MARK: - Handlers
    private var tableHandler: TransferListTableHandler?
    private var cancellables = Set<AnyCancellable>()

    // MARK: - Lifecycle
    public override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupHandlers()
        bindViewModel()
        viewModel?.refreshTransfers()
    }

    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel?.loadFavorites()
        transferTableView.reloadData()
    }
    
    public override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        updateNavigationBarAppearance()
        transferTableView.reloadData()
    }

    deinit {
        print("🧹 Deinit: TransferListViewController")
    }
}

// MARK: - Setup
private extension TransferListViewController {

    func setupUI() {
        title = "Transfers List"

        // Table
        transferTableView.registerCell(TransferCell.self, module: .module)
        transferTableView.registerCell(FavoriteTableViewCell.self, module: .module)
        transferTableView.backgroundColor = .background3
        transferTableView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)

        // Search
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = true

        updateNavigationBarAppearance()
    }

    func setupHandlers() {
        guard let viewModel else { return }
        tableHandler = TransferListTableHandler(tableView: transferTableView, viewModel: viewModel, actionDelegate: self)
    }

    @objc func handleRefresh() {
        guard let viewModel else { return }
        searchController.searchBar.text = ""
        viewModel.changedTextSearch(with: "")
        viewModel.refreshTransfers()
    }

    func updateNavigationBarAppearance() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .background3
        appearance.titleTextAttributes = [.foregroundColor: UIColor.text1]

        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
    }
}

// MARK: - Bindings
private extension TransferListViewController {

    func bindViewModel() {
        guard let viewModel else { return }

        viewModel.onUpdatePublisher
            .sink { [weak self] in
                guard let self, let viewModel = self.viewModel else { return }
                if viewModel.transfersCount == 0 {
                    self.transferTableView.setEmptyMessage("No Transfer Found")
                } else {
                    self.transferTableView.restore()
                }
                self.refreshControl.endRefreshing()
                self.transferTableView.reloadData()
            }
            .store(in: &cancellables)

        viewModel.onErrorPublisher
            .sink { [weak self] message in
                self?.showErrorAlert(title: "Error", message: message)
            }
            .store(in: &cancellables)

        viewModel.onLoadingStatePublisher
            .sink { [weak self] isLoading in
                self?.setLoading(isLoading)
            }
            .store(in: &cancellables)
    }
}

// MARK: - Search
extension TransferListViewController: UISearchResultsUpdating {
    public func updateSearchResults(for searchController: UISearchController) {
        guard let viewModel else { return }
        let text = searchController.searchBar.text ?? ""
        viewModel.changedTextSearch(with: text.trimmingCharacters(in: .whitespacesAndNewlines))
    }
}

// MARK: - Header Actions Delegate
extension TransferListViewController: TransferListActionDelegate {

    func didTapSort() {
        let alert = UIAlertController(title: "Sort Transfers", message: "Choose a sorting option", preferredStyle: .actionSheet)

        SortOption.allCases.forEach { sort in
            alert.addAction(UIAlertAction(title: sort.rawValue, style: .default) { [weak self] _ in
                guard let viewModel = self?.viewModel else { return }
                viewModel.sortOption = sort
            })
        }
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(alert, animated: true)
    }

    func didTapEdit() {
        guard let viewModel else { return }
        viewModel.toggleCanEdit()
        transferTableView.reloadData()
    }
}
