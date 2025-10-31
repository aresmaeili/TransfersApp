//
//  CardView.swift
//  TransferFeature
//
//  Created by AREM on 10/31/25.
//

import UIKit

class CardView: UIView, ViewConnectable {
    
    @IBOutlet weak var parentView: UIView!
    @IBOutlet weak var logoLabel: UILabel!
    @IBOutlet weak var maskedNumberLabel: UILabel!
    @IBOutlet weak var dueDateLabel: UILabel!
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var toggleFavoriteButton: UIButton!
    
    var isFavorite: Bool = false
    
//    // MARK: - Init
//    required init?(coder aDecoder: NSCoder) {
//        super.init(coder: aDecoder)
//        setupView()
//    }
//    
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        setupView()
//    }
    
    required init() {
        
        super.init(frame: .zero)
        
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func initialize() {
        connectView()
        setupView()
//        setupData(kgText: kgText, bagage: bagage, flightWay: flightWay, flightLine: flightLine, flighttype: flighttype)
    }
    
    
    private func setupView() {
        parentView.backgroundColor = .appBackground5
        parentView.layer.cornerRadius = 22
        parentView.layer.borderWidth = 1
        parentView.layer.borderColor = UIColor.appBorder1.cgColor
        
        logoLabel.font = UIFont.systemFont(ofSize: 14, weight: .black).withTraits(.traitItalic)
        logoLabel.textColor = .appText11
        
        maskedNumberLabel.font = UIFont.systemFont(ofSize: 18, weight: .black)
        maskedNumberLabel.textColor = .appText11
        
        dueDateLabel.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        dueDateLabel.textColor = .appText11
        
        amountLabel.font = UIFont.systemFont(ofSize: 32, weight: .bold)
        amountLabel.textColor = .appText11
        
        toggleFavoriteButton.layer.cornerRadius = 10
        toggleFavoriteButton.backgroundColor = .appText8
        toggleFavoriteButton.setTitle(isFavorite ? "Unfavorite" : "Favorite", for: .normal)
        toggleFavoriteButton.setImage( UIImage(named: isFavorite ? "star.fill" : "star"), for: .normal)
        toggleFavoriteButton.setTitleColor(.appText1, for: .normal)
        toggleFavoriteButton.addTarget(self, action: #selector(toggleFavorite), for: .touchUpInside)
    }
    
    @objc func toggleFavorite() {
        isFavorite.toggle()
        toggleFavoriteButton.setTitle(isFavorite ? "Unfavorite" : "Favorite", for: .normal)
        toggleFavoriteButton.setImage( UIImage(named: isFavorite ? "star.fill" : "star"), for: .normal)
    }
    
    func configure(cardNumber: String, dueDate: String, amount: String) {
        maskedNumberLabel.text = cardNumber
        dueDateLabel.text = "Due Date \(dueDate)"
        amountLabel.text = amount
    }
}

extension UIFont {
    func withTraits(_ traits: UIFontDescriptor.SymbolicTraits) -> UIFont {
        guard let descriptor = fontDescriptor.withSymbolicTraits(traits) else {
            return self
        }
        return UIFont(descriptor: descriptor, size: pointSize)
    }
}


import UIKit

@MainActor
protocol ViewConnectable {
    func connectView()
}

extension ViewConnectable where Self: UIView {
     func connectView() {
        let name = getName()
         let nib = UINib(nibName: name, bundle: .module)
        let views = nib.instantiate(withOwner: self, options: nil)
        guard let view = views.first as? UIView else { return }
        addExpletiveSubView(view: view)
    }
    
    // MARK: - ByPass Generic Names
    private func getName() -> String {
        var name = String(describing: Self.self)
        if let genericTypeRange = name.range(of: "<") {
          name.removeSubrange(genericTypeRange.lowerBound..<name.endIndex)
        }
        return name
    }
}

extension UIView {
    public func addExpletiveSubView(view: UIView, height: CGFloat? = nil) {
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        view.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        view.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        view.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        view.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        if let height = height, height > 0 {
            view.heightAnchor.constraint(equalToConstant: height).isActive = true
        }
    }
}
