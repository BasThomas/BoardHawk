//
//  Column.swift
//  
//
//  Created by Bas Thomas Broek on 24/09/2020.
//

import Foundation

struct Column: Hashable, Decodable {
    let id: Int
    let name: String
    let projectURL: URL
    let cardsURL: URL
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case projectURL = "project_url"
        case cardsURL = "cards_url"
    }
}
