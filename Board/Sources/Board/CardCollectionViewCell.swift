//
//  CardCollectionViewCell.swift
//  
//
//  Created by Bas Thomas Broek on 24/09/2020.
//

import UIKit

class CardCollectionViewCell: UICollectionViewCell {
    let noteLabel = UILabel()

    var card: Card! {
        didSet {
            noteLabel.text = card.note
            backgroundColor = card.isArchived ? .systemRed : .systemGray
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configureUI() {
        noteLabel.font = .preferredFont(forTextStyle: .body)
        noteLabel.adjustsFontForContentSizeCategory = true
        noteLabel.numberOfLines = 0

        let stackView = UIStackView(arrangedSubviews: [noteLabel])
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.alignment = .fill
        stackView.spacing = 5

        noteLabel.translatesAutoresizingMaskIntoConstraints = false
        stackView.translatesAutoresizingMaskIntoConstraints = false

        let container = self.contentView

        container.addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: container.trailingAnchor),
            stackView.topAnchor.constraint(equalTo: container.topAnchor),
            stackView.bottomAnchor.constraint(lessThanOrEqualTo: container.bottomAnchor)
        ])
    }
}
