//
//  GetGenresUseCase.swift
//  MoviePlay
//
//  Created by Anthony Rubio on 25/07/24.
//

import Foundation

import Combine

protocol GetGenresUseCase {
    func execute(lenguage: String) -> AnyPublisher<Genres, Error>
}

class GetGenresUseCaseImpl: GetGenresUseCase {
    private let apiClient: APIClientDatasource

    init(apiClient: APIClientDatasource) {
        self.apiClient = apiClient
    }

    func execute(lenguage: String) -> AnyPublisher<Genres, Error> {
        return apiClient.fetchGenders(lenguage: lenguage)
    }
}
