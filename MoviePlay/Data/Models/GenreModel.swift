//
//  GenreModel.swift
//  MoviePlay
//
//  Created by Anthony Rubio on 25/07/24.
//

import Foundation

struct Genres: Codable {
    let genres: [GenreModel]
}

struct GenreModel: Codable, Hashable {
    let id: Int
    let name: String
}
