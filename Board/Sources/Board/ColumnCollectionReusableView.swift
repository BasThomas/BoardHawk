//
//  ColumnCollectionReusableView.swift
//  
//
//  Created by Bas Thomas Broek on 25/09/2020.
//

import UIKit

class ColumnCollectionReusableView: UICollectionReusableView {
    let titleLabel = UILabel()
    let addCardButton = UIButton()
    let configureButton = UIButton()
    var column: Column! {
        didSet {
            titleLabel.text = column.name
            setupHandlers()
        }
    }
    var viewController: UIViewController!

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configureUI() {
        titleLabel.font = .preferredFont(forTextStyle: .title1)
        titleLabel.adjustsFontForContentSizeCategory = true

        addCardButton.setImage(
            UIImage(systemName: "plus.circle"),
            for: .normal
        )
        addCardButton.accessibilityLabel = NSLocalizedString(
            "Add Card",
            comment: "Add card to columm button"
        )
        addCardButton.isPointerInteractionEnabled = true

        configureButton.setImage(
            UIImage(systemName: "ellipsis.circle"),
            for: .normal
        )
        configureButton.accessibilityLabel = NSLocalizedString(
            "Configure Column",
            comment: "Column configuration button"
        )
        configureButton.isPointerInteractionEnabled = true

        let stackView = UIStackView(
            arrangedSubviews: [
                titleLabel,
                addCardButton,
                configureButton
            ]
        )
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.alignment = .fill
        stackView.spacing = 5

        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        configureButton.translatesAutoresizingMaskIntoConstraints = false
        addCardButton.translatesAutoresizingMaskIntoConstraints = false
        stackView.translatesAutoresizingMaskIntoConstraints = false

        let container = self

        container.addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: container.trailingAnchor),
            stackView.topAnchor.constraint(equalTo: container.topAnchor),
            stackView.bottomAnchor.constraint(lessThanOrEqualTo: container.bottomAnchor)
        ])
    }

    private func setupHandlers() {
        guard let column = column else { fatalError("Column should not be nil when setting up handlers")}
        let edit = UIAction(
            title: "Edit",
            image: UIImage(systemName: "pencil")
        ) { _ in
            print("Edit column \(column)")
        }

        let archive = UIAction(
            title: "Archive all cards",
            image: UIImage(systemName: "archivebox")
        ) { _ in
            print("Archive all cards in colunn \(column)")
        }

        let copyOrShare = UIAction.board.share(
            url: column.url,
            copyTitle: "Copy column URL",
            shareTitle: "Share column",
            from: .view(configureButton),
            in: viewController
        )

        let delete = UIAction(
            title: "Delete column",
            image: UIImage(systemName: "trash"),
            attributes: [.destructive]
        ) { _ in
            print("Delete \(column)")
        }

        #if !targetEnvironment(macCatalyst)
        addCardButton.addAction(UIAction { _ in
            print("add card")
        }, for: .touchUpInside)

        configureButton.menu = .init(
            title: "",
            children: [
                edit, archive, copyOrShare, delete
        ])
        configureButton.showsMenuAsPrimaryAction = true
        #else
        #warning("Only available starting with Big Sur...")
        #endif
    }
}
