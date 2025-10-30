//
//  TransferListViewController.swift
//  TransfersApp
//
//  Created by AREM on 10/30/25.
//

import UIKit
import NetworkCore
import RouterCore

public class TransferListViewController: UIViewController {
    
    @IBOutlet private weak var transfeTableView: UITableView!

    var viewModel: TransferListViewModel?
    var router: Coordinator?
    
    public override func viewDidLoad() {
        super.viewDidLoad()
         title = "Transfers list"
        transfeTableView.register(UINib(nibName: "TransferCell", bundle: .module), forCellReuseIdentifier: "TransferCell")
        transfeTableView.dataSource = self
        transfeTableView.delegate = self
        viewModel?.loadTransfers()

    }
}

extension TransferListViewController: UITableViewDataSource, UITableViewDelegate {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel?.transfers.count ?? 0
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TransferCell", for: indexPath) as! TransferCell
        cell.configCell(name: viewModel?.transfers[indexPath.row].person?.fullName ?? "")
        return cell
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        100
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Tapped on row: \(viewModel?.transfers[indexPath.row].person?.fullName ?? "-")")
        
    }
}

extension TransferListViewController: TransferListDelegate {
    func didGetTransfers() {
        transfeTableView.reloadData()
    }

    func getTransfersError(_ message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
}

//TODO: Change loc this
import Foundation

public extension Bundle {
    static var transferFeature: Bundle {
        return .module
    }
}
