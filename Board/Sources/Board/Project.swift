//
//  Project.swift
//  
//
//  Created by Bas Thomas Broek on 24/09/2020.
//

import Foundation

public struct Project: Hashable, Decodable {
    public let id: Int
    public let name: String
    public let body: String?
    public let columnURL: URL?
}
