//
//  UICOllectionView-extensions.swift
//  Shared
//
//  Created by AREM on 10/31/25.
//
import UIKit

public extension UICollectionView {
    func registerCell<T: UICollectionViewCell>(_ cell: T.Type) {
        self.register(UINib(nibName: String(describing: cell), bundle: .module), forCellWithReuseIdentifier: String(describing: cell))
    }

    func dequeueCell<T: UICollectionViewCell>(_ cell: T.Type, indexPath: IndexPath) -> T {
        let cell = self.dequeueReusableCell(withReuseIdentifier: String(describing: cell), for: indexPath) as! T
        return cell
    }
}
