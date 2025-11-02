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
        guard let viewModel else { return }
        viewModel.toggleFavorite()
        let image = viewModel.isFavorite ? UIImage.shared(named: "StarFill") : UIImage.shared(named: "Star")
        starbutton.setImage(image, for: .normal)
    }
    
    weak var viewModel: TransferDetailsViewModelInput?
    
    required init(viewModel: TransferDetailsViewModel?) {
        
        super.init(frame: .zero)
        guard let viewModel else { return }
        self.viewModel = viewModel
        initialize(viewModel: viewModel)
     
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func initialize(viewModel: TransferDetailsViewModel) {
        self.viewModel = viewModel
        connectView(bundle: .module)
        setupView()
        configure(viewModel: viewModel)
    }
    
    private func setupView() {
        parentView.backgroundColor = .background1
        parentView.layer.cornerRadius = 32
        parentView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        parentView.clipsToBounds = true
        
        avatarParentView.layer.cornerRadius = 16
        avatarParentView.backgroundColor = .background3
        avatarParentView.layer.borderColor = UIColor.border1.cgColor
        avatarParentView.layer.borderWidth = 2
        avatarParentView.clipsToBounds = true
        
        avatarImageView.contentMode = .scaleAspectFill
        
        nameLabel.font = .systemFont(ofSize: 24, weight: .bold)
        nameLabel.textColor = .text1

        mailLabel.font = .systemFont(ofSize: 16, weight: .medium)
        mailLabel.textColor = .text3
        
        totalLabel.font = .systemFont(ofSize: 48, weight: .bold)
        totalLabel.textColor = .text6
        
    }
    
    private func configure(viewModel: TransferDetailsViewModel?) {
        guard let data = viewModel?.cardViewData, let isFavorite = viewModel?.isFavorite else { return }
        nameLabel.text = data.name
        mailLabel.text = data.mail
        totalLabel.text = data.totalAmount
        let image = isFavorite ? UIImage.shared(named: "StarFill") : UIImage.shared(named: "Star")
        starbutton.setImage(image, for: .normal)
        loadAvatar(from: data.avatar)
        
    }
    
    private var avatarTask: Task<Void, Never>?

    private func loadAvatar(from urlString: String?) {
        avatarTask?.cancel()
        avatarTask = Task {
            guard let urlString else { return }
            if let image = try? await ImageDownloader.shared.downloadImage(from: urlString) {
                await MainActor.run {
                    self.avatarImageView.image = image
                }
            }
        }
    }
}
