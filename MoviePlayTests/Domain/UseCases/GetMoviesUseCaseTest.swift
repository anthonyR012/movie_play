//
//  GetMoviesUseCaseTest.swift
//  MoviePlayTests
//
//  Created by Anthony Rubio on 26/07/24.
//

import Combine
@testable import MoviePlay
import XCTest

final class GetMoviesUseCaseTests: XCTestCase {
    var sut: GetMoviesUseCaseImpl!
    var apiClientMock: APIClientDatasourceMock!
    var cancellables: Set<AnyCancellable>!

    override func setUpWithError() throws {
        try super.setUpWithError()
        apiClientMock = APIClientDatasourceMock()
        sut = GetMoviesUseCaseImpl(apiClient: apiClientMock)
        cancellables = []
    }

    override func tearDownWithError() throws {
        sut = nil
        apiClientMock = nil
        cancellables = nil
        try super.tearDownWithError()
    }

    func testExecute_withSearchQuery_shouldReturnSearchResults() {
        // Given
        let expectedMovies = Movies(page: 1, results: [], totalPages: 100, totalResults: 1000)
        apiClientMock.searchMoviesResult = .success(expectedMovies)
        let filters = MovieFiltersModel(adult: false, originalLanguage: .en, popularity: .asc, category: .popular, page: 1, query: "text", typeFilter: .all)
        let expectation = XCTestExpectation(description: "Search results received")

        // When
        sut.execute(filters: filters)
            .sink(receiveCompletion: { completion in
                if case let .failure(error) = completion {
                    XCTFail("Expected success, got failure with \(error)")
                }
            }, receiveValue: { movies in
                // Then
                XCTAssertEqual(movies.results, expectedMovies.results)
                expectation.fulfill()
            })
            .store(in: &cancellables)

        wait(for: [expectation], timeout: 1.0)
    }

    func testExecute_withoutQuery_shouldReturnAllMovies() {
        // Given
        let expectedMovies = Movies(page: 1, results: [], totalPages: 100, totalResults: 1000)
        apiClientMock.fetchMoviesResult = .success(expectedMovies)
        let filters = MovieFiltersModel(adult: false, originalLanguage: .en, popularity: .asc, category: .popular, page: 100, query: "", typeFilter: .all)
        let expectation = XCTestExpectation(description: "All movies received")

        // When
        sut.execute(filters: filters)
            .sink(receiveCompletion: { completion in
                if case let .failure(error) = completion {
                    XCTFail("Expected success, got failure with \(error)")
                }
            }, receiveValue: { movies in
                // Then
                XCTAssertEqual(movies.results, expectedMovies.results)
                expectation.fulfill()
            })
            .store(in: &cancellables)

        wait(for: [expectation], timeout: 1.0)
    }
}
