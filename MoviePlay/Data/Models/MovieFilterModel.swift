//
//  MovieFilterModel.swift
//  MoviePlay
//
//  Created by Anthony Rubio on 24/07/24.
//

import Foundation

struct MovieFiltersModel {
    var adult: Bool
    var originalLanguage: OriginalLanguage
    var popularity: Popularity
}

enum OriginalLanguage: String, Codable {
    case en = "en"
    case fr = "fr"
    case zh = "zh"
}


enum Popularity : String, Codable {
    case asc = "popularity.asc"
    case desc = "popularity.desc"
}
