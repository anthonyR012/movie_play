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
        token = ProcessInfo.processInfo.environment["TOKEN"] ?? ""
        baseUrl = ProcessInfo.processInfo.environment["BASE_URL"] ?? ""
        baseUrlImage = ProcessInfo.processInfo.environment["BASE_URL_IMAGE"] ?? ""
    }

    var token: String
    var baseUrl: String
    var baseUrlImage: String
}
