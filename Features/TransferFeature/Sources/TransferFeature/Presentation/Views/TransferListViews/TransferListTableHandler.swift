//
//  TransferListActionDelegate.swift
//  TransferFeature
//
//  Created by AREM on 11/13/25.
//

import UIKit
import Shared

protocol TransferListActionDelegate: AnyObject {
    func didTapSort()
    func didTapEdit()
}

@MainActor
final class TransferListTableHandler: NSObject {

    private weak var tableView: UITableView?
    private weak var viewModel: TransferListViewModelProtocol?
    private weak var actionDelegate: TransferListActionDelegate?

    init(tableView: UITableView,
         viewModel: TransferListViewModelProtocol,
         actionDelegate: TransferListActionDelegate) {
        self.tableView = tableView
        self.viewModel = viewModel
        self.actionDelegate = actionDelegate
        super.init()
        tableView.dataSource = self
        tableView.delegate = self
    }
}

// MARK: - Sections
private enum ListSection: Int, CaseIterable {
    case favorites
    case transfers

    var height: CGFloat {
        switch self {
        case .favorites: return 160
        case .transfers: return 100
        }
    }

    var title: String {
        switch self {
        case .favorites: return "Favorites:"
        case .transfers: return "Transfers:"
        }
    }
}

extension TransferListTableHandler: UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        ListSection.allCases.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let viewModel else { return 0 }
        switch ListSection(rawValue: section)! {
        case .favorites:
            return viewModel.hasFavoriteRow ? 1 : 0
        case .transfers:
            return viewModel.transfersCount
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        guard let section = ListSection(rawValue: indexPath.section),
              let vm = viewModel else { return UITableViewCell() }

        switch section {

        case .favorites:
            guard let cell: FavoriteTableViewCell = tableView.dequeueCell(FavoriteTableViewCell.self) else { return UITableViewCell()}
            cell.configure(with: vm)
            return cell

        case .transfers:
            guard let cell: TransferCell = tableView.dequeueCell(TransferCell.self) else { return UITableViewCell()}
            if let transfer = vm.getTransferItem(at: indexPath.row) {
                cell.configCell(data: transfer, isFavorite: vm.checkIsFavorite(transfer))
            }
            return cell
        }
    }
}

extension TransferListTableHandler: UITableViewDelegate {

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        ListSection(rawValue: indexPath.section)!.height
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        shouldShowHeader(section) ? UITableView.automaticDimension : 0
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard shouldShowHeader(section), let section = ListSection(rawValue: section), let vm = viewModel else { return nil }

        let view = TransferSectionHeaderView(title: section.title, isFavorites: section == .favorites, isEditing: vm.canEdit, sortName: vm.sortOption.rawValue, delegate: actionDelegate)
        return view
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let vm = viewModel, let transfer = vm.getTransferItem(at: indexPath.row), let section = ListSection(rawValue: indexPath.section), section == .transfers else { return }
        vm.routeToDetails(for: transfer)
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        guard let section = ListSection(rawValue: indexPath.section), section == .transfers else { return }
        if editingStyle == .delete {
            guard let viewModel, let item = viewModel.getTransferItem(at: indexPath.row) else { return }
            tableView.beginUpdates()
            viewModel.removeItems(item: item)
            tableView.deleteRows(at: [indexPath], with: .automatic)
            tableView.endUpdates()
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
          guard let section = ListSection(rawValue: indexPath.section), section == .transfers, let currentItem = viewModel?.getTransferItem(at: indexPath.row) else { return }
          viewModel?.loadNextPageIfNeeded(currentItem: currentItem)
      }
}

// MARK: - Helpers
private extension TransferListTableHandler {
    func shouldShowHeader(_ section: Int) -> Bool {
        guard let section = ListSection(rawValue: section), let vm = viewModel else { return false }
        if section == .favorites { return vm.hasFavoriteRow }
        return true
    }
}
