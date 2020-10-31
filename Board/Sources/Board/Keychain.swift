//
//  Keychain.swift
//  BoardHawk
//
//  Created by Bas Broek on 27/10/2020.
//

import Foundation

struct Keychain {
    struct Error: Swift.Error {
        let status: OSStatus
    }
    func add(data: Data, for tag: String) throws {
        let query = [
          kSecValueData: data,
          kSecAttrServer: "github.com",
          kSecClass: kSecClassInternetPassword
        ] as CFDictionary

        SecItemDelete(query)
        let status = SecItemAdd(query, nil)
        guard status == errSecSuccess else { throw Error(status: status) }
    }
    
    func retrieve(tag: String) throws -> Data {
        let query = [
          kSecClass: kSecClassInternetPassword,
          kSecAttrServer: "github.com",
          kSecReturnData: true
        ] as CFDictionary

        var result: CFTypeRef?
        let status = SecItemCopyMatching(query, &result)
        guard status == errSecSuccess else { throw Error(status: status) }
        let data = result as! Data
        
        return data
    }
}
