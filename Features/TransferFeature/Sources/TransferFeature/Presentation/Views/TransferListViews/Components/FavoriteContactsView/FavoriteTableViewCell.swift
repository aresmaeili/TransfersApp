//
//  FavoriteTableViewCell.swift
//  TransferFeature
//
//  Created by AREM on 10/30/25.
//

import UIKit

// MARK: - FavoriteTableViewCell
class FavoriteTableViewCell: UITableViewCell {

    @IBOutlet private weak var collectionView: UICollectionView!
    private var viewModel: TransferListViewModelInput?
    
    // MARK: - Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        
        Task { @MainActor in
                setupCollectionView()
        }
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

    // MARK: - Configuration
    func configure(with viewModel: TransferListViewModelInput) {
        self.viewModel = viewModel
        collectionView.reloadData()
    }
}

extension FavoriteTableViewCell: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel?.favoriteCounts ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FavoriteCollectionViewCell", for: indexPath) as! FavoriteCollectionViewCell
        
        guard let viewModel, let favorite = viewModel.getFavorite(at: indexPath.row) else { return cell }
        cell.configure(with: favorite, viewModel: viewModel)
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let height = collectionView.bounds.height
        return CGSize(width: height * 0.8 , height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let favorite = viewModel?.getFavoriteTransfer(at: indexPath.row) else { return }
        viewModel?.routeToDetails(for: favorite)
    }
}
