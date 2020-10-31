//
//  Token.swift
//  BoardHawk
//
//  Created by Bas Broek on 27/10/2020.
//

import Foundation

public struct Token: Decodable {
    private static let tag = "com.githawk.BoardHawk"
    public let accessToken: String
    
    public func saveToKeychain() throws {
        try Keychain().add(data: Data(accessToken.utf8), for: Self.tag)
    }
    
    public static func retrieveFromKeychain() throws -> Self {
        let data = try Keychain().retrieve(tag: Self.tag)
        
        return Token(accessToken: String(decoding: data, as: UTF8.self))
    }
}
