//
//  TransferListViewController.swift
//  TransfersApp
//
//  Created by AREM on 10/30/25.
//

import UIKit

public class TransferListViewController: UIViewController {
    
    @IBOutlet private weak var transfeTableView: UITableView!

    public override func viewDidLoad() {
        super.viewDidLoad()
        
        transfeTableView.register(UINib(nibName: "TransferCell", bundle: .module), forCellReuseIdentifier: "TransferCell")
        transfeTableView.dataSource = self
        transfeTableView.delegate = self
    }
}

extension TransferListViewController: UITableViewDataSource, UITableViewDelegate {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        10
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TransferCell", for: indexPath) as! TransferCell
        return cell
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        100
    }
}

import Foundation

public extension Bundle {
    static var transferFeature: Bundle {
        return .module
    }
}
