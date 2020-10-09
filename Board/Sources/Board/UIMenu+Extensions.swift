//
//  UIMenu+Extensions.swift
//  
//
//  Created by Bas Thomas Broek on 25/09/2020.
//

import UIKit

enum Source {
    case barButtonItem(UIBarButtonItem)
    case view(UIView)
}

struct BoardMenus {
    func share(
        url: URL,
        title: String,
        from source: Source,
        in viewController: UIViewController
    ) -> UIAction {
        let shareAction = UIAction(
            title: title,
            image: UIImage(systemName: "square.and.arrow.up")
        ) { _ in
            let activityViewController = UIActivityViewController(
                activityItems: [url],
                applicationActivities: nil
            )
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
            switch source {
            case .barButtonItem(let barButtonItem):
                activityViewController.popoverPresentationController?.barButtonItem = barButtonItem
            case .view(let view):
                activityViewController.popoverPresentationController?.sourceView = view
                activityViewController.popoverPresentationController?.sourceRect = CGRect(origin: view.center, size: .zero)
            }
            viewController.present(activityViewController, animated: true)
        }

        return shareAction
    }
}

extension UIAction {
    static var board: BoardMenus {
        .init()
    }
}
