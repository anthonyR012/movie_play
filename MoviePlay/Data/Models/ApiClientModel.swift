//
//  ApiClientModel.swift
//  MoviePlay
//
//  Created by Anthony Rubio on 24/07/24.
//

import Foundation
import Combine

protocol APIClient {
    func fetchMovies(category: String, page: Int, filters: MovieFiltersModel) -> AnyPublisher<Movies, Error>
}

class APIClientImpl: APIClient {
    private let baseURL = "https://api.themoviedb.org/3"
    private let token = "eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiJlYWJiYTI0Mzk3YTgxMjc5NDgwMzE1OTgyMTQ0NjhjNSIsIm5iZiI6MTcyMTg2NTkwMy41MzE3NTEsInN1YiI6IjY2YTE3YWE0YTY3YWI5YzZiZDM4MWU4YyIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.osqtjZIYZAlxdO9pgCm_r2tLoA9eYu8Jt4xWAG_Gagc"
    
        
    
    func fetchMovies(category: String, page: Int, filters: MovieFiltersModel) -> AnyPublisher<Movies, Error> {
        var urlComponents = URLComponents(string: "\(baseURL)/movie/\(category)")!
        urlComponents.queryItems = [
            URLQueryItem(name: "page", value: "\(page)"),
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
        print(url)
        return session.dataTaskPublisher(for: url)
            .map(\.data)
            .receive(on: DispatchQueue.main)
            .decode(type: Movies.self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }
    
    
    func discoverMovies(page: Int, filters: MovieFiltersModel) -> AnyPublisher<Movies, Error> {
        var urlComponents = URLComponents(string: "\(baseURL)/discover/movie/")!
        urlComponents.queryItems = [
            URLQueryItem(name: "page", value: "\(page)"),
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
        print(url)
        return session.dataTaskPublisher(for: url)
            .map(\.data)
            .receive(on: DispatchQueue.main)
            .decode(type: Movies.self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }
    
    func searchMovies(query: String?, page: Int, filters: MovieFiltersModel) -> AnyPublisher<Movies, Error> {
        var urlComponents = URLComponents(string: "\(baseURL)/discover/movie/")!
        urlComponents.queryItems = [
            URLQueryItem(name: "page", value: "\(page)"),
            URLQueryItem(name: "include_adult", value: "\(filters.adult)"),
            URLQueryItem(name: "language", value: filters.originalLanguage.rawValue),
            URLQueryItem(name: "sort_by", value: filters.popularity.rawValue),
            URLQueryItem(name: "query", value: filters.popularity.rawValue),
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
