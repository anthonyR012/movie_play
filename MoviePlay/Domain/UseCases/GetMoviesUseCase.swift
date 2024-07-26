//
//  GetMoviesUseCase.swift
//  MoviePlay
//
//  Created by Anthony Rubio on 24/07/24.
//

import Combine
import Foundation

protocol GetMoviesUseCase {
    func execute(filters: MovieFiltersModel) -> AnyPublisher<Movies, Error>
}

class GetMoviesUseCaseImpl: GetMoviesUseCase {
    private let apiClient: APIClientDatasource

    init(apiClient: APIClientDatasource) {
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
            return apiClient.fetchMovies(filters: filters)
        }
    }
}
