//
//  SplitViewController.swift
//  BoardHawk
//
//  Created by Bas Thomas Broek on 25/09/2020.
//

import UIKit

class SplitViewController: UISplitViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        primaryBackgroundStyle = .sidebar
        let rootViewController: UIViewController
        #if !targetEnvironment(macCatalyst)
        preferredDisplayMode = .oneBesideSecondary
        let config = UICollectionLayoutListConfiguration(appearance: .insetGrouped)
        let layout = UICollectionViewCompositionalLayout.list(using: config)
        rootViewController = ProjectsCollectionViewController(collectionViewLayout: layout)
        #else
        rootViewController = ProjectsTableViewController()
        #endif
        let navigationController = UINavigationController(rootViewController: rootViewController)
        navigationController.navigationBar.prefersLargeTitles = true
        #if !targetEnvironment(macCatalyst)
        setViewController(navigationController, for: .primary)
        #else
        viewControllers = [navigationController]
        #endif
    }
}
