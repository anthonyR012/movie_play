//
//  Mocks.swift
//  MoviePlayTests
//
//  Created by Anthony Rubio on 26/07/24.
//
import Combine
@testable import MoviePlay
import XCTest

class MockURLProtocol: URLProtocol {
    static var requestHandler: ((URLRequest) -> (HTTPURLResponse, Data))?

    override class func canInit(with _: URLRequest) -> Bool {
        return true
    }

    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }

    override func startLoading() {
        guard let handler = MockURLProtocol.requestHandler else {
            fatalError("Handler is unavailable.")
        }

        let (response, data) = handler(request)

        client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
        client?.urlProtocol(self, didLoad: data)
        client?.urlProtocolDidFinishLoading(self)
    }

    override func stopLoading() {}
}

class APIClientDatasourceMock: APIClientDatasource {
    var searchMoviesResult: Result<Movies, Error>?
    var fetchMoviesResult: Result<Movies, Error>?
    var fetchGendersResult: Result<Genres, Error>?

    func fetchMovies(filters _: MovieFiltersModel) -> AnyPublisher<Movies, Error> {
        if let result = fetchMoviesResult {
            return result.publisher.eraseToAnyPublisher()
        } else {
            return Fail(error: NSError(domain: "No result set", code: -1, userInfo: nil))
                .eraseToAnyPublisher()
        }
    }

    func searchMovies(filters _: MovieFiltersModel) -> AnyPublisher<Movies, Error> {
        if let result = searchMoviesResult {
            return result.publisher.eraseToAnyPublisher()
        } else {
            return Fail(error: NSError(domain: "No result set", code: -1, userInfo: nil))
                .eraseToAnyPublisher()
        }
    }

    func fetchGenders(lenguage _: String) -> AnyPublisher<Genres, Error> {
        if let result = fetchGendersResult {
            return result.publisher.eraseToAnyPublisher()
        } else {
            return Fail(error: NSError(domain: "No result set", code: -1, userInfo: nil))
                .eraseToAnyPublisher()
        }
    }
}
