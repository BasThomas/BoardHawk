//
//  UIMenu+Extensions.swift
//  
//
//  Created by Bas Thomas Broek on 25/09/2020.
//

import UIKit

struct BoardMenus {
    func copyOrShare(
        url: URL,
        copyTitle: String,
        shareTitle: String,
        from viewController: UIViewController
    ) -> UIAction {
        let copyOrShare: UIAction
        #if targetEnvironment(macCatalyst)
        copyOrShare = .init(
            title: copyTitle,
            image: UIImage(systemName: "doc.on.doc")
        ) { _ in
            UIPasteboard.general.string = url.absoluteString
        }
        #else
        copyOrShare = .init(
            title: shareTitle,
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
            viewController.present(activityViewController, animated: true)
        }
        #endif

        return copyOrShare
    }
}

extension UIAction {
    static var board: BoardMenus {
        .init()
    }
}
