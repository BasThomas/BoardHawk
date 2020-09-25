//
//  Column.swift
//  
//
//  Created by Bas Thomas Broek on 24/09/2020.
//

import Foundation

public struct Column: Hashable {
    let id = UUID()
    public let name: String
    let url: URL = URL(string: "https://apple.com")!
    var __cards: [Card]

    public init(name: String) {
        self.name = name
        __cards = [
            .init(
                note: "Can’t see photos on Readme",
                isArchived: false
            ),
            .init(
                note: "Latest review comments are missing",
                isArchived: false
            ),
            .init(
                note: "Redirect images not loading",
                isArchived: false
            ),
            .init(
                note: "App accounts open as user accounts, which 404",
                isArchived: false
            ),
            .init(
                note: "Quoted markdown formatted incorrectly",
                isArchived: false
            )
        ]
    }
}
