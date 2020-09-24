//
//  Project.swift
//  
//
//  Created by Bas Thomas Broek on 24/09/2020.
//

public struct Project {
    public let name: String
    public let body: String?

    public init(
        name: String,
        body: String?
    ) {
        self.name = name
        self.body = body
    }
}
