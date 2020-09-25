import UIKit

public class BoardViewController: UIViewController, UICollectionViewDelegate {
    let project: Project

    private var collectionView: UICollectionView!
    private(set) var dataSource: UICollectionViewDiffableDataSource<Column, Card>!

    public init(project: Project) {
        self.project = project
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = project.name
        addCollectionView()
        configureCollectionView()
    }

    private func addCollectionView() {
        let layout = makeCompositionalLayout()

        collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: layout
        )
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.alwaysBounceVertical = true
        collectionView.contentInset.top = 20
        collectionView.backgroundColor = .systemBackground

        view.addSubview(collectionView)

        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    private func configureCollectionView() {
        collectionView.register(
            CardCollectionViewCell.self,
            forCellWithReuseIdentifier: "card"
        )

        collectionView.delegate = self
        configureDiffableDataSource()
    }

    func makeCompositionalLayout() -> UICollectionViewLayout {
        let configuration = UICollectionViewCompositionalLayoutConfiguration()
        configuration.interSectionSpacing = 20

        let layout = UICollectionViewCompositionalLayout(
            sectionProvider: { [weak self] _, _ -> NSCollectionLayoutSection? in
                guard let self = self else {
                    return nil
                }

                let section = self.makeColumnLayoutSection()

                section.contentInsets = NSDirectionalEdgeInsets(
                    top: 0,
                    leading: 10,
                    bottom: 0,
                    trailing: 10
                )
                section.orthogonalScrollingBehavior = .continuousGroupLeadingBoundary
                return section

            }, configuration: configuration)

        return layout
    }

    func makeColumnLayoutSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(1.0)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(0.9),
            heightDimension: .absolute(100)
        )
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: groupSize,
            subitem: item,
            count: 1
        )

        group.interItemSpacing = NSCollectionLayoutSpacing.fixed(10)

        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 10

        return section
    }

    func configureDiffableDataSource() {
        // FIXME: Only available in Big Sur+; see https://twitter.com/steipete/status/1309389856066482177
//        let registration = UICollectionView.CellRegistration<CardCollectionViewCell, Card> { cell, indexPath, card in
//            cell.card = card
//        }
//        let dataSource = UICollectionViewDiffableDataSource<Column, Card>(
//            collectionView: collectionView
//        ) { collectionView, indexPath, card -> UICollectionViewCell in
//            collectionView.dequeueConfiguredReusableCell(
//                using: registration,
//                for: indexPath,
//                item: card
//            )
//        }

        let dataSource = UICollectionViewDiffableDataSource<Column, Card>(
            collectionView: collectionView
        ) { (collectionView, indexPath, card) -> UICollectionViewCell? in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "card", for: indexPath) as! CardCollectionViewCell
            cell.card = card
            return cell
        }

        self.dataSource = dataSource

        updateSnapshot(animated: false)
    }

    func updateSnapshot(
        animated: Bool = true
    ) {
        var snapshot = NSDiffableDataSourceSnapshot<Column, Card>()

        snapshot.appendSections(project.__columns)
        project.__columns.forEach { column in
            snapshot.appendItems(column.__cards, toSection: column)
        }

        dataSource.apply(
            snapshot,
            animatingDifferences: animated
        )
    }

    public func collectionView(
        _ collectionView: UICollectionView,
        didSelectItemAt indexPath: IndexPath
    ) {
        let card = project.__columns[indexPath.section].__cards[indexPath.row]
        print(card)
    }

    public func collectionView(
        _ collectionView: UICollectionView,
        contextMenuConfigurationForItemAt indexPath: IndexPath,
        point: CGPoint
    ) -> UIContextMenuConfiguration? {
        let card = project.__columns[indexPath.section].__cards[indexPath.row]
        return UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { suggestedActions in
            let copyOrShare: UIAction
            #if targetEnvironment(macCatalyst)
            copyOrShare = .init(
                title: "Copy card link",
                image: UIImage(systemName: "doc.on.doc")
            ) { _ in
                UIPasteboard.general.string = card.url.absoluteString
            }
            #else
            copyOrShare = .init(
                title: "Share card",
                image: UIImage(systemName: "square.and.arrow.up")
            ) { _ in
                let activityViewController = UIActivityViewController(activityItems: [card.url], applicationActivities: nil)
                activityViewController.excludedActivityTypes = [
                    .mail,
                    .assignToContact,
                    .postToWeibo,
                    .postToVimeo,
                    .postToFlickr,
                    .postToFacebook,
                    .postToTencentWeibo,
                    .openInIBooks,
                    .print,
                    .saveToCameraRoll,
                    .markupAsPDF
                ]
                self.present(activityViewController, animated: true)
            }
            #endif

            let archive = UIAction(
                title: "Archive",
                image: UIImage(systemName: "archivebox")
            ) { _ in
                print("Archive card \(card)")
            }

            let remove = UIAction(
                title: "Remove from project",
                image: UIImage(systemName: "trash"),
                attributes: [.destructive]
            ) { _ in
                print("Remove card \(card)")
            }

            return UIMenu(title: "", children: [copyOrShare, archive, remove])
        }
    }
}
