//
//  ProjectsTableViewController.swift
//  BoardHawk
//
//  Created by Bas Thomas Broek on 24/09/2020.
//

import UIKit
import Board

#if !targetEnvironment(macCatalyst)
class ProjectsCollectionViewController: UICollectionViewController {
    private(set) var dataSource: UICollectionViewDiffableDataSource<Int, Project>!
    var projects: [Project] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = NSLocalizedString("Projects", comment: "Project overview title")
        
        configureDiffableDatasource()
        
        let owner = "GithawkApp"
        let repo = "GitHawk"
        var req = URLRequest(url: URL(string: "https://api.github.com/repos/\(owner)/\(repo)/projects")!)
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
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            do {
                let projects = try decoder.decode([Project].self, from: data)
                self.projects = projects
                DispatchQueue.main.async {
                    self.updateSnapshot(animated: true)
                }
            } catch {
                #warning("TODO: error handling")
                print(error)
            }
        }
        task.resume()
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
#endif

#if targetEnvironment(macCatalyst)
@available(macCatalyst, deprecated: 14.0, message: "Use CollectionView alternative instead.")
class DetailTableViewCell: UITableViewCell {
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

@available(macCatalyst, deprecated: 14.0, message: "Use CollectionView alternative instead.")
class ProjectsTableViewController: UITableViewController {
    var projects: [Project] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        title = NSLocalizedString("Projects", comment: "Project overview title")
        self.projects = [
            .init(name: "Bugs", body: "Bug management and prioritization."),
            .init(name: "Pull Request Release")
        ]
        tableView.register(DetailTableViewCell.self, forCellReuseIdentifier: "project")
    }

    // MARK: - Table view data source

    override func numberOfSections(
        in tableView: UITableView
    ) -> Int {
        1 // later more, perhaps, separated by states?
    }

    override func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int
    ) -> Int {
        projects.count
    }

    override func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: "project",
            for: indexPath
        ) as! DetailTableViewCell

        let project = projects[indexPath.row]

        cell.textLabel?.text = project.name
        cell.detailTextLabel?.text = project.body

        return cell
    }

    override func tableView(
        _ tableView: UITableView,
        didSelectRowAt indexPath: IndexPath
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

    override func tableView(
        _ tableView: UITableView,
        contextMenuConfigurationForRowAt indexPath: IndexPath,
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
#endif
