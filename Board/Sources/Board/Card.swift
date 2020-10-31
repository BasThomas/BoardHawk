//
//  Card.swift
//  
//
//  Created by Bas Thomas Broek on 24/09/2020.
//

import Foundation

struct Card: Hashable, Decodable {
    let id: Int
    let note: String?
    let isArchived: Bool
    let url: URL
    
    enum CodingKeys: String, CodingKey {
        case id
        case note
        case isArchived = "archived"
        case url
    }
}
