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

class ProfileView: UIView, ViewConnectable {
    
    @IBOutlet weak var parentView: UIView!
    @IBOutlet weak var avatarParentView: UIView!
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var starImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var mailLabel: UILabel!
    @IBOutlet weak var totalLabel: UILabel!

    required init() {
        
        super.init(frame: .zero)
        
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func initialize() {
        connectView(bundle: .module)
        setupView()
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
        
        starImageView.image = UIImage.shared(named: "StarFill")
    }
    
    
    func configure(with data: TransferDetailsProfileProtocol) {
        nameLabel.text = data.name
        mailLabel.text = data.mail
        totalLabel.text = data.totalAmount
        loadAvatar(from: data.avatarUser)
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
