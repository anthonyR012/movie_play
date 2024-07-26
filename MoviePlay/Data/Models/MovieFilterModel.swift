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
    var category: CategoryMovie
    var page: Int
    var query: String
    var typeFilter: FilterType
}

enum OriginalLanguage: String, Codable, CaseIterable {
    case en
    case fr
    case zh
}

enum Popularity: String, Codable, CaseIterable {
    case asc = "popularity.asc"
    case desc = "popularity.desc"
}

enum CategoryMovie: String, Codable, CaseIterable {
    case popular
    case topRated = "top_rated"
}

enum FilterType: Codable {
    case search, all
}
