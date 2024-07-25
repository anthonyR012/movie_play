//
//  GetMoviesUseCase.swift
//  MoviePlay
//
//  Created by Anthony Rubio on 24/07/24.
//

import Foundation
import Combine

protocol GetMoviesUseCase {
    func execute(category: String, page: Int, filters: MovieFiltersModel) -> AnyPublisher<Movies, Error>
}

class GetMoviesUseCaseImpl: GetMoviesUseCase {
    private let apiClient: APIClient
    
    init(apiClient: APIClient) {
        self.apiClient = apiClient
    }
    
    func execute(category: String, page: Int, filters: MovieFiltersModel) -> AnyPublisher<Movies, Error> {
        return apiClient.fetchMovies(category: category, page: page, filters: filters)
    }
}
