import UIKit

public class BoardViewController: UIViewController, UICollectionViewDelegate {
    let project: Project
    private var data: [Column: [Card]] = [:]

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
        navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem
        navigationItem.leftItemsSupplementBackButton = true
        
        // get collumns
        var req = URLRequest(url: URL(string: "https://api.github.com/projects/\(project.id)/columns")!)
        req.httpMethod = "GET"
        req.setValue(
            "application/vnd.github.inertia-preview+json",
            forHTTPHeaderField: "Accept"
        )
        
        req.setValue(
            "token \(try! Token.retrieveFromKeychain().accessToken)",
            forHTTPHeaderField: "Authorization"
        )
        let task = URLSession.shared.dataTask(
            with: req
        ) { data, response, error in
            #warning("TODO: error handling")
            guard error == nil else { fatalError(error!.localizedDescription) }
            #warning("TODO: error handling")
            guard let data = data else { fatalError("No data") }
            let decoder = JSONDecoder()
            do {
                let columns = try decoder.decode([Column].self, from: data)
                var _data: [Column: [Card]] = [:]
                columns.forEach {
                    _data[$0] = []
                }
                self.data = _data
                DispatchQueue.main.async {
                    self.updateSnapshot(animated: true)
                }
                columns.forEach { column in
                    var req = URLRequest(url: URL(string: "https://api.github.com/projects/columns/\(column.id)/cards")!)
                    req.httpMethod = "GET"
                    req.setValue(
                        "application/vnd.github.inertia-preview+json",
                        forHTTPHeaderField: "Accept"
                    )
                    
                    req.setValue(
                        "token \(try! Token.retrieveFromKeychain().accessToken)",
                        forHTTPHeaderField: "Authorization"
                    )
                    let task = URLSession.shared.dataTask(
                        with: req
                    ) { data, response, error in
                        #warning("TODO: error handling")
                        guard error == nil else { fatalError(error!.localizedDescription) }
                        #warning("TODO: error handling")
                        guard let data = data else { fatalError("No data") }
                        let decoder = JSONDecoder()
                        do {
                            print(try JSONSerialization.jsonObject(with: data))
                            let cards = try decoder.decode([Card].self, from: data)
                            self.data[column] = cards
                            DispatchQueue.main.async {
                                self.updateSnapshot(animated: true)
                            }
                        } catch {
                            print(error)
                        }
                    }
                    task.resume()
                }
            } catch {
                #warning("TODO: error handling")
                print(error)
            }
        }
        task.resume()
        // get cards for columns
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
        // FIXME: Not necesary once switching to `CellRegistration`
        collectionView.register(
            CardCollectionViewCell.self,
            forCellWithReuseIdentifier: "card"
        )
        collectionView.register(
            ColumnCollectionReusableView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: "column"
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

                let headerSize = NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1.0),
                    heightDimension: .estimated(20)
                )
                let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(
                    layoutSize: headerSize,
                    elementKind: UICollectionView.elementKindSectionHeader,
                    alignment: .top
                )
                section.boundarySupplementaryItems = [sectionHeader]
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
        let dataSource: UICollectionViewDiffableDataSource<Column, Card>
        #if targetEnvironment(macCatalyst)
        dataSource = .init(
            collectionView: collectionView
        ) { (collectionView, indexPath, card) -> UICollectionViewCell? in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "card", for: indexPath) as! CardCollectionViewCell
            cell.card = card
            return cell
        }
        #else
        let registration = UICollectionView.CellRegistration<CardCollectionViewCell, Card> { cell, indexPath, card in
            cell.card = card
        }
        dataSource = .init(
            collectionView: collectionView
        ) { collectionView, indexPath, card -> UICollectionViewCell in
            collectionView.dequeueConfiguredReusableCell(
                using: registration,
                for: indexPath,
                item: card
            )
        }
        #endif

        dataSource.supplementaryViewProvider = { collectionView, kind, indexPath in
            guard kind == UICollectionView.elementKindSectionHeader else {
                return nil
            }
            let cell = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: "column",
                for: indexPath
            ) as! ColumnCollectionReusableView
            let column = self.dataSource.snapshot().sectionIdentifiers[indexPath.section]
            cell.viewController = self
            cell.column = column
            return cell
        }

        self.dataSource = dataSource

        updateSnapshot(animated: false)
    }

    func updateSnapshot(
        animated: Bool = true
    ) {
        var snapshot = NSDiffableDataSourceSnapshot<Column, Card>()

        snapshot.appendSections(Array(data.keys))
        data.forEach { column, cards in
            snapshot.appendItems(cards, toSection: column)
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
//        let card = project.__columns[indexPath.section].__cards[indexPath.row]
//        print(card)
    }

    public func collectionView(
        _ collectionView: UICollectionView,
        contextMenuConfigurationForItemAt indexPath: IndexPath,
        point: CGPoint
    ) -> UIContextMenuConfiguration? {
        return nil
//        let card = project.__columns[indexPath.section].__cards[indexPath.row]
//        return UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { suggestedActions in
//            let copyOrShare = UIAction.board.share(
//                url: card.url,
//                title: "Share card",
//                from: .view(collectionView.cellForItem(at: indexPath)!),
//                in: self
//            )
//
//            let archive = UIAction(
//                title: "Archive",
//                image: UIImage(systemName: "archivebox")
//            ) { _ in
//                print("Archive card \(card)")
//            }
//
//            let remove = UIAction(
//                title: "Remove from project",
//                image: UIImage(systemName: "trash"),
//                attributes: [.destructive]
//            ) { _ in
//                print("Remove card \(card)")
//            }
//
//            return UIMenu(title: "", children: [copyOrShare, archive, remove])
//        }
    }
}
