//
//  Project.swift
//  
//
//  Created by Bas Thomas Broek on 24/09/2020.
//

import Foundation

public struct Project {
    let id = UUID()
    public let name: String
    public let body: String?
    public var __columns: [Column]

    public init(
        name: String,
        body: String? = nil
    ) {
        self.name = name
        self.body = body
        __columns = [
            .init(name: "Needs triage"),
            .init(name: "High priority")
        ]
    }
}
