//
//  TransferSectionHeaderView.swift
//  TransferFeature
//
//  Created by AREM on 11/13/25.
//

import UIKit

final class TransferSectionHeaderView: UIView {

    weak var delegate: TransferListActionDelegate?

    init(title: String, isFavorites: Bool, isEditing: Bool, sortName: String, delegate: TransferListActionDelegate?) {
        super.init(frame: .zero)
        self.delegate = delegate
        setupLayout(title: title, isFavorites: isFavorites, isEditing: isEditing, sortName: sortName)
    }

    required init?(coder: NSCoder) { fatalError() }

    private func setupLayout(title: String, isFavorites: Bool, isEditing: Bool, sortName: String) {

        backgroundColor = .clear

        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.font = .preferredFont(forTextStyle: .headline)

        let button = UIButton(type: .system)
        if isFavorites {
            button.setTitle(isEditing ? "Done" : "Edit", for: .normal)
            button.addAction(UIAction { [weak self] _ in
                self?.delegate?.didTapEdit()
            }, for: .touchUpInside)

        } else {
            button.setTitle("Sort: \(sortName)", for: .normal)
            button.addAction(UIAction { [weak self] _ in
                self?.delegate?.didTapSort()
            }, for: .touchUpInside)
        }

        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        button.translatesAutoresizingMaskIntoConstraints = false

        addSubview(titleLabel)
        addSubview(button)

        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor),

            button.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            button.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
}
