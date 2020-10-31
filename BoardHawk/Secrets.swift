//
//  Secrets.swift
//  BoardHawk
//
//  Created by Bas Broek on 31/10/2020.
//

import Foundation

enum Secrets {
    enum GitHub {
        static let clientID = Secrets.environmentVariable(named: "GITHUB_CLIENT_ID")
        static let clientSecret = Secrets.environmentVariable(named: "GITHUB_CLIENT_SECRET")
    }
    
    fileprivate static func environmentVariable(
        named: String
    ) -> String? {
        let processInfo = ProcessInfo.processInfo
        
        guard let variable = processInfo.environment[named] else {
            print("‼️ Missing Environment Variable: '\(named)'")
            return nil
        }
        return variable
    }
}
