//
//  FavoriteTableViewCell.swift
//  TransferFeature
//
//  Created by AREM on 10/30/25.
//

import UIKit

class FavoriteTableViewCell: UITableViewCell {

    @IBOutlet weak var FavoriteTitleLabel: UILabel!
    @IBOutlet private weak var collectionView: UICollectionView!
    var transfers: [Transfer] = []

    override func awakeFromNib() {
        super.awakeFromNib()
//        TODO: check this
        setupCollectionView()
    }

    private func setupCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 12
        layout.sectionInset = .init(top: 0, left: 16, bottom: 0, right: 16)

        collectionView.collectionViewLayout = layout
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = .clear
        collectionView.register(UINib(nibName: "FavoriteCollectionViewCell", bundle: .module), forCellWithReuseIdentifier: "FavoriteCollectionViewCell")

    }
    
//TODO: fix this
    func configure(with transfers: [Transfer]) {
            self.transfers = transfers
            collectionView.reloadData()
    }
}

extension FavoriteTableViewCell: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        transfers.count
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FavoriteCollectionViewCell", for: indexPath) as! FavoriteCollectionViewCell
        cell.configure(with: transfers[indexPath.item])
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let height = collectionView.bounds.height
              return CGSize(width: 100, height: height)
    }
}

