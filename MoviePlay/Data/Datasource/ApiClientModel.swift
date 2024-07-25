//
//  ApiClientModel.swift
//  MoviePlay
//
//  Created by Anthony Rubio on 24/07/24.
//

import Foundation
import Combine

protocol APIClientDatasource {
    func fetchMovies(filters: MovieFiltersModel) -> AnyPublisher<Movies, Error>
    func searchMovies(filters: MovieFiltersModel) -> AnyPublisher<Movies, Error>
    func fetchImage(url: String) -> AnyPublisher<Data, Error> 
    func fetchGenders(lenguage: String) -> AnyPublisher<Genres, Error>
}

class APIClientDatasourceImpl: APIClientDatasource {
    private let baseURL : String
    private let baseImageURL : String
    private let token : String
    private let session : URLSession
    
    init(baseURL: String, token: String, baseImageURL: String) {
        self.baseImageURL = baseImageURL
        self.baseURL = baseURL
        self.token = token
        let sessionConfiguration = URLSessionConfiguration.default
        sessionConfiguration.httpAdditionalHeaders = [
            "Authorization": "Bearer \(token)"
        ]
        let session = URLSession(configuration: sessionConfiguration)
    }
    
    
    func fetchMovies( filters: MovieFiltersModel) -> AnyPublisher<Movies, Error> {
        var urlComponents = URLComponents(string: "\(baseURL)/movie/\(filters.category.rawValue)")!
        urlComponents.queryItems = [
            URLQueryItem(name: "page", value: "\(filters.page)"),
            URLQueryItem(name: "include_adult", value: "\(filters.adult)"),
            URLQueryItem(name: "language", value: filters.originalLanguage.rawValue),
            URLQueryItem(name: "sort_by", value: filters.popularity.rawValue),
        ]
        let url = urlComponents.url! 
        return session.dataTaskPublisher(for: url)
            .map(\.data)
            .receive(on: DispatchQueue.main)
            .decode(type: Movies.self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }
    
    
    
    func searchMovies( filters: MovieFiltersModel) -> AnyPublisher<Movies, Error> {
        var urlComponents = URLComponents(string: "\(baseURL)/search/movie")!
        urlComponents.queryItems = [
            URLQueryItem(name: "page", value: "\(filters.page)"),
            URLQueryItem(name: "include_adult", value: "\(filters.adult)"),
            URLQueryItem(name: "language", value: filters.originalLanguage.rawValue),
            URLQueryItem(name: "sort_by", value: filters.popularity.rawValue),
            URLQueryItem(name: "query", value: filters.query),
        ]
        let url = urlComponents.url!
        return session.dataTaskPublisher(for: url)
            .map(\.data)
            .receive(on: DispatchQueue.main)
            .decode(type: Movies.self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }

    func fetchImage (url: String) -> AnyPublisher<Data, Error> {
        let url = URL(string: baseImageURL)!
        return session.dataTaskPublisher(for: url)
            .map(\.data)
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }


    func fetchGenders(lenguage: String) -> AnyPublisher<Genres, Error> {
        var urlComponents = URLComponents(string: "\(baseURL)/genre/movie/list")!
        urlComponents.queryItems = [
            URLQueryItem(name: "language", value: lenguage),
        ]
        let url = urlComponents.url!
        return session.dataTaskPublisher(for: url)
            .map(\.data)
            .receive(on: DispatchQueue.main)
            .decode(type: Genres.self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }
    
}
