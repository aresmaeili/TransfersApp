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

public extension UITableView {
    func setEmptyMessage(_ message: String) {
        let messageLabel = UILabel(frame: CGRect(x: 0, y: 0,
                                                 width: self.bounds.size.width,
                                                 height: self.bounds.size.height))
        messageLabel.text = message
        messageLabel.textColor = .gray
        messageLabel.numberOfLines = 0
        messageLabel.textAlignment = .center
        messageLabel.font = UIFont.systemFont(ofSize: 17, weight: .medium)
        messageLabel.sizeToFit()

        self.backgroundView = messageLabel
        self.separatorStyle = .none
    }

    func restore() {
        self.backgroundView = nil
    }
}
