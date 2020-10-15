//
//  AppDelegate.swift
//  BoardHawk
//
//  Created by Bas Thomas Broek on 24/09/2020.
//

import UIKit

// FIXME: Only available in Big Sur+
//@main
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        true
    }

    // MARK: UISceneSession Lifecycle

    func application(
        _ application: UIApplication,
        configurationForConnecting connectingSceneSession: UISceneSession,
        options: UIScene.ConnectionOptions
    ) -> UISceneConfiguration {
        .init(
            name: "Default Configuration",
            sessionRole: connectingSceneSession.role
        )
    }
}
