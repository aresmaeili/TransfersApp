//
//  CardView.swift
//  TransferFeature
//
//  Created by AREM on 10/31/25.
//
import UIKit
import Shared
import NetworkCore

protocol TransferDetailsProfileProtocol {
    var name: String { get }
    var avatarUser: String { get }
    var mail: String { get }
    var totalAmount: String { get }
//    var note: String? { get }
}

@MainActor
protocol profileViewDelegate: AnyObject {
    func didSelectStarButton(transfer: Transfer, shouldBeFavorite: Bool)
}

class ProfileView: UIView, ViewConnectable {
    
    @IBOutlet weak var parentView: UIView!
    @IBOutlet weak var avatarParentView: UIView!
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var starbutton: UIButton!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var mailLabel: UILabel!
    @IBOutlet weak var totalLabel: UILabel!

    @IBAction func starButtonAction(_ sender: Any) {
        guard let transfer, let delegate, let isFavorite else { return }
        self.isFavorite?.toggle()
        delegate.didSelectStarButton(transfer: transfer, shouldBeFavorite: isFavorite)
        setupStarButton(isFavorite: isFavorite)
    }
    
    weak var delegate: profileViewDelegate?
    var transfer: Transfer?
    var isFavorite: Bool?
    
    required init(data: Transfer, delegate: profileViewDelegate, isFavorite: Bool) {
        
        super.init(frame: .zero)
        
        self.delegate = delegate
        self.transfer = data
        self.isFavorite = isFavorite
        
        initialize(with: data, isFavorite: isFavorite)
     
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func initialize(with data: any TransferDetailsProfileProtocol, isFavorite: Bool) {
        connectView(bundle: .module)
        setupView()
        configure(with: data, isFavorite: isFavorite)
    }
    
    private func setupView() {
        parentView.backgroundColor = .appBackground1
        parentView.layer.cornerRadius = 32
        parentView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        parentView.clipsToBounds = true
        
        avatarParentView.layer.cornerRadius = 16
        avatarParentView.backgroundColor = .appBackground3
        avatarParentView.layer.borderColor = UIColor.appBorder1.cgColor
        avatarParentView.layer.borderWidth = 1
        avatarParentView.clipsToBounds = true
        
        avatarImageView.contentMode = .scaleAspectFill
        
        nameLabel.font = .systemFont(ofSize: 24, weight: .bold)
        nameLabel.textColor = .appText1

        mailLabel.font = .systemFont(ofSize: 14, weight: .medium)
        mailLabel.textColor = .appText3
        
        totalLabel.font = .systemFont(ofSize: 48, weight: .bold)
        totalLabel.textColor = .appText6
        
    }
    
    
    func configure(with data: TransferDetailsProfileProtocol, isFavorite: Bool) {
        nameLabel.text = data.name
        mailLabel.text = data.mail
        totalLabel.text = data.totalAmount
        self.isFavorite = isFavorite
        loadAvatar(from: data.avatarUser)
        setupStarButton(isFavorite: isFavorite)
    }
    
    func setupStarButton(isFavorite: Bool) {
        let image = isFavorite ? UIImage.shared(named: "StarFill") : UIImage.shared(named: "Star")
        starbutton.setImage(image, for: .normal)
    }
    
    // MARK: Private Helpers
    private func loadAvatar(from urlString: String?) {
        guard let urlString = urlString else { return }
        
        if let cachedImage = ImageCache.shared.image(forKey: urlString) {
            avatarImageView.image = cachedImage
            return
        }

        //        Todo: Change this loc
                Task { [weak self] in
                    guard let self else { return }
                    do {
                        guard let image = try await ImageDownloader.shared.downloadImage(from: urlString)  else { return }
                        ImageCache.shared.setImage(image, forKey: urlString)
                        await MainActor.run {
                            self.avatarImageView.image = image
                        }
                    } catch {
                        print("Error: \(error)")
                    }
                }
    }
}
