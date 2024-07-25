//
//  Configuration.swift
//  MoviePlay
//
//  Created by Anthony Rubio on 24/07/24.
//

import Foundation

class Configuration {
    static let shared = Configuration()
    
    private init() {
        self.token = ProcessInfo.processInfo.environment["TOKEN"] ?? ""
        self.baseUrl = ProcessInfo.processInfo.environment["BASE_URL"] ?? ""
    }
    
    var token: String
    var baseUrl: String
}
