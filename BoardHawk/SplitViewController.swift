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
        #if !targetEnvironment(macCatalyst)
        preferredDisplayMode = .oneBesideSecondary
        #endif
    }
}
