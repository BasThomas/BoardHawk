//
//  Card.swift
//  
//
//  Created by Bas Thomas Broek on 24/09/2020.
//

import Foundation

public struct Card: Hashable {
    let id = UUID()
    let note: String
    let isArchived: Bool
    let url: URL = URL(string: "https://www.apple.com/")!
}
