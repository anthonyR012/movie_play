//
//  ApiClientModel.swift
//  MoviePlay
//
//  Created by Anthony Rubio on 24/07/24.
//

import Foundation
import Combine

protocol APIClient {
    func fetchMovies(filters: MovieFiltersModel) -> AnyPublisher<Movies, Error>
    func searchMovies(filters: MovieFiltersModel) -> AnyPublisher<Movies, Error>
}

class APIClientImpl: APIClient {
    private let baseURL : String
    private let token : String
    
    init(baseURL: String, token: String) {
        self.baseURL = baseURL
        self.token = token
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
            
        let sessionConfiguration = URLSessionConfiguration.default
        sessionConfiguration.httpAdditionalHeaders = [
            "Authorization": "Bearer \(token)"
        ]
        let session = URLSession(configuration: sessionConfiguration)
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
        
        let sessionConfiguration = URLSessionConfiguration.default
        sessionConfiguration.httpAdditionalHeaders = [
            "Authorization": "Bearer \(token)"
        ]
        let session = URLSession(configuration: sessionConfiguration)
        print(url)
        return session.dataTaskPublisher(for: url)
            .map(\.data)
            .receive(on: DispatchQueue.main)
            .decode(type: Movies.self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }
    
}
