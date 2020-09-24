//
//  ProjectsTableViewController.swift
//  BoardHawk
//
//  Created by Bas Thomas Broek on 24/09/2020.
//

import UIKit
import Board

class ProjectsTableViewController: UITableViewController {
    var projects: [Project] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        self.projects = [
            .init(name: "Bugs", body: "Bug management and prioritization.")
        ]
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
        )

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
        navigationController?.pushViewController(BoardViewController(project: project), animated: true)
    }
}
