//
//  UITableView-extension.swift
//  Shared
//
//  Created by AREM on 10/31/25.
//
import UIKit

public extension UITableView {
    func registerCell<T: UITableViewCell>(_ cell: T.Type, module: Bundle?) {
        self.register(UINib(nibName: String(describing: cell), bundle: module), forCellReuseIdentifier: String(describing: cell))
    }

    func dequeueCell<T: UITableViewCell>(_ cell: T.Type) -> T? {
        guard let cell = self.dequeueReusableCell(withIdentifier: String(describing: cell)) as? T else { return nil }
        cell.selectionStyle = .none
        return cell
    }
}
