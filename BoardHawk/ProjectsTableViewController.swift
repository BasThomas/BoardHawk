//
//  ProjectsTableViewController.swift
//  BoardHawk
//
//  Created by Bas Thomas Broek on 24/09/2020.
//

import UIKit
import Board

class ProjectsCollectionViewController: UICollectionViewController {
    private(set) var dataSource: UICollectionViewDiffableDataSource<Int, Project>!
    var projects: [Project] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = NSLocalizedString("Projects", comment: "Project overview title")
        self.projects = [
            .init(name: "Bugs", body: "Bug management and prioritization."),
            .init(name: "Pull Request Release")
        ]
        
        configureDiffableDatasource()
    }
    
    func configureDiffableDatasource() {
        let dataSource: UICollectionViewDiffableDataSource<Int, Project>
        let registration = UICollectionView.CellRegistration<UICollectionViewListCell, Project> { cell, indexPath, project in
            // Configuring each cell's content:
            var configuration = cell.defaultContentConfiguration()
            configuration.text = project.name
            configuration.secondaryText = project.body
            cell.contentConfiguration = configuration
        }
        
        dataSource = .init(
            collectionView: collectionView
        ) { collectionView, indexPath, project -> UICollectionViewCell in
            collectionView.dequeueConfiguredReusableCell(
                using: registration,
                for: indexPath,
                item: project
            )
        }
        
        self.dataSource = dataSource
        updateSnapshot(animated: false)
    }
    
    func updateSnapshot(
        animated: Bool = true
    ) {
        var snapshot = NSDiffableDataSourceSnapshot<Int, Project>()

        snapshot.appendSections([0])
        snapshot.appendItems(projects)

        dataSource.apply(
            snapshot,
            animatingDifferences: animated
        )
    }
    
    override func numberOfSections(
        in collectionView: UICollectionView
    ) -> Int {
        1 // later more, perhaps, separated by states?
    }
    
    override func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        projects.count
    }
    
    override func collectionView(
        _ collectionView: UICollectionView,
        didSelectItemAt indexPath: IndexPath
    ) {
        let project = projects[indexPath.row]
        let controller = UINavigationController(
            rootViewController: BoardViewController(project: project)
        )
        navigationController?.showDetailViewController(
            controller,
            sender: self
        )
    }
    
    override func collectionView(
        _ collectionView: UICollectionView,
        contextMenuConfigurationForItemAt indexPath: IndexPath,
        point: CGPoint
    ) -> UIContextMenuConfiguration? {
        let project = projects[indexPath.row]

        return UIContextMenuConfiguration(
            identifier: nil,
            previewProvider: nil
        ) { suggestedActions in
            let edit = UIAction(
                title: "Edit",
                image: UIImage(systemName: "pencil")
            ) { _ in
                print("Edit project \(project)")
            }

            let close = UIAction(
                title: "Close",
                image: UIImage(systemName: "pencil.slash"),
                attributes: [.destructive]
            ) { _ in
                print("Close project \(project)")
            }

            return UIMenu(title: "", children: [edit, close])
        }
    }
}
