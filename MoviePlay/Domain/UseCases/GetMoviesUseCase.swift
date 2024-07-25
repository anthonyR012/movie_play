//
//  GetMoviesUseCase.swift
//  MoviePlay
//
//  Created by Anthony Rubio on 24/07/24.
//

import Foundation
import Combine

protocol GetMoviesUseCase {
    func execute( filters: MovieFiltersModel) -> AnyPublisher<Movies, Error>
}

class GetMoviesUseCaseImpl: GetMoviesUseCase {
    private let apiClient: APIClient
    
    init(apiClient: APIClient) {
        self.apiClient = apiClient
    }
    
    func execute(filters: MovieFiltersModel) -> AnyPublisher<Movies, Error> {
        var typeFilter = filters.typeFilter
        if !filters.query.isEmpty {
            typeFilter = .search
        } else {
            typeFilter = .all
        }
        switch typeFilter {
        case .search:
            return apiClient.searchMovies(filters: filters)
        case .all:
            return apiClient.fetchMovies( filters: filters)
        
        }
        
    }
}
