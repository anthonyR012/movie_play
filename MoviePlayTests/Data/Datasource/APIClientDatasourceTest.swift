//
//  APIClientDatasourceTest.swift
//  MoviePlayTests
//
//  Created by Anthony Rubio on 26/07/24.
//

import Combine
@testable import MoviePlay
import XCTest

class APIClientDatasourceTests: XCTestCase {
    var sut: APIClientDatasourceImpl!
    var cancellables: Set<AnyCancellable> = []

    override func setUpWithError() throws {
        try super.setUpWithError()

        let sessionConfiguration = URLSessionConfiguration.default
        sessionConfiguration.protocolClasses = [MockURLProtocol.self]
        let session = URLSession(configuration: sessionConfiguration)

        sut = APIClientDatasourceImpl(baseURL: "https://api.themoviedb.org/3", token: "your_token")
        sut.session = session
    }

    override func tearDownWithError() throws {
        sut = nil
        cancellables.removeAll()
        try super.tearDownWithError()
    }

    func testFetchMovies() throws {
        let mockData = """
        {
            "results": [],
            "page": 1,
            "total_results": 0,
            "total_pages": 0
        }
        """.data(using: .utf8)!

        MockURLProtocol.requestHandler = { request in
            let response = HTTPURLResponse(
                url: request.url!,
                statusCode: 200,
                httpVersion: nil,
                headerFields: nil
            )!
            return (response, mockData)
        }

        let filters = MovieFiltersModel(adult: false, originalLanguage: .en, popularity: .asc, category: .popular, page: 1, query: "", typeFilter: .all)

        let expectation = XCTestExpectation(description: "FetchMovies completes")

        sut.fetchMovies(filters: filters)
            .sink(receiveCompletion: { completion in
                if case let .failure(error) = completion {
                    XCTFail("Error: \(error)")
                }
            }, receiveValue: { movies in
                XCTAssertEqual(movies.results.count, 0)
                expectation.fulfill()
            })
            .store(in: &cancellables)

        wait(for: [expectation], timeout: 1.0)
    }

    func testSearchMovies() throws {
        let mockData = """
        {
            "results": [],
            "page": 1,
            "total_results": 0,
            "total_pages": 0
        }
        """.data(using: .utf8)!

        MockURLProtocol.requestHandler = { request in
            let response = HTTPURLResponse(
                url: request.url!,
                statusCode: 200,
                httpVersion: nil,
                headerFields: nil
            )!
            return (response, mockData)
        }

        let filters = MovieFiltersModel(adult: false, originalLanguage: .en, popularity: .asc, category: .popular, page: 1, query: "Test", typeFilter: .all)

        let expectation = XCTestExpectation(description: "SearchMovies completes")

        sut.searchMovies(filters: filters)
            .sink(receiveCompletion: { completion in
                if case let .failure(error) = completion {
                    XCTFail("Error: \(error)")
                }
            }, receiveValue: { movies in
                XCTAssertEqual(movies.results.count, 0)
                expectation.fulfill()
            })
            .store(in: &cancellables)

        wait(for: [expectation], timeout: 1.0)
    }

    func testFetchGenders() throws {
        let mockData = """
        {
            "genres": []
        }
        """.data(using: .utf8)!

        MockURLProtocol.requestHandler = { request in
            let response = HTTPURLResponse(
                url: request.url!,
                statusCode: 200,
                httpVersion: nil,
                headerFields: nil
            )!
            return (response, mockData)
        }

        let expectation = XCTestExpectation(description: "FetchGenders completes")

        sut.fetchGenders(lenguage: "en")
            .sink(receiveCompletion: { completion in
                if case let .failure(error) = completion {
                    XCTFail("Error: \(error)")
                }
            }, receiveValue: { genres in
                XCTAssertEqual(genres.genres.count, 0)
                expectation.fulfill()
            })
            .store(in: &cancellables)

        wait(for: [expectation], timeout: 1.0)
    }
}

