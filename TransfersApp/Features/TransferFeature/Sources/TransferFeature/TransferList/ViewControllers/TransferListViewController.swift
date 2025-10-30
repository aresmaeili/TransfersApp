//
//  TransferListViewController.swift
//  TransfersApp
//
//  Created by AREM on 10/30/25.
//

import UIKit
import NetworkCore

public class TransferListViewController: UIViewController {
    
    @IBOutlet private weak var transfeTableView: UITableView!

    var transfers: [Transfer] = [] {
        didSet {
            transfeTableView.reloadData()
        }
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        transfeTableView.register(UINib(nibName: "TransferCell", bundle: .module), forCellReuseIdentifier: "TransferCell")
        transfeTableView.dataSource = self
        transfeTableView.delegate = self
        Task {
            do {
                transfers = try await execute()
            } catch {
                print("Errorrrr: \(error.localizedDescription)")
            }
        }
    }
}

extension TransferListViewController: UITableViewDataSource, UITableViewDelegate {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        transfers.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TransferCell", for: indexPath) as! TransferCell
        cell.configCell(name: transfers[indexPath.row].person?.fullName ?? "")
        return cell
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        100
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}

extension TransferListViewController {
    func execute() async throws -> [Transfer] {
        let endpoint = TransferListEndpoint()
        let result: [Transfer] = try await NetworkClient.shared.get(endPoint: endpoint)
        return result
    }
}

//TODO: Change loc this
import Foundation

public extension Bundle {
    static var transferFeature: Bundle {
        return .module
    }
}

