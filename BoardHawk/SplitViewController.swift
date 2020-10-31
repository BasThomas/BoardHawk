//
//  SplitViewController.swift
//  BoardHawk
//
//  Created by Bas Thomas Broek on 25/09/2020.
//

import UIKit
import AuthenticationServices

class SplitViewController: UISplitViewController, ASWebAuthenticationPresentationContextProviding {
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
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let session = ASWebAuthenticationSession(
            url: URL(string: "https://github.com/login/oauth/authorize?client_id=\(Secrets.GitHub.clientID!)")!,
            callbackURLScheme: "boardhawk"
        ) { callbackURL, error in
            guard error == nil, let callbackURL = callbackURL else {
                switch error! {
                case ASWebAuthenticationSessionError.canceledLogin: break
                default: (); #warning("TODO: error handling")
                }
                return
            }
            
            guard let items = URLComponents(
                url: callbackURL,
                resolvingAgainstBaseURL: false
            )?.queryItems,
            let index = items.firstIndex(where: { $0.name == "code" }),
            let code = items[index].value else { return }
            
            var req = URLRequest(url: URL(string: "https://github.com/login/oauth/access_token?client_id=\(Secrets.GitHub.clientID!)&client_secret=\(Secrets.GitHub.clientSecret!)&code=\(code)")!)
            req.httpMethod = "POST"
            req.setValue(
                "application/json",
                forHTTPHeaderField: "Accept"
            )
            let task = URLSession.shared.dataTask(
                with: req
            ) { data, response, error in
                print(data, response, error)
                print(try! JSONSerialization.jsonObject(with: data!))
            }
            task.resume()
        }
        
        session.presentationContextProvider = self
//        session.prefersEphemeralWebBrowserSession = true // should this be an option for the user?
        session.start()
    }
    
    func presentationAnchor(
        for session: ASWebAuthenticationSession
    ) -> ASPresentationAnchor {
        view.window!
    }
}
