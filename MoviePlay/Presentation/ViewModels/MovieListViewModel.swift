//
//  MovieListViewModel.swift
//  MoviePlay
//
//  Created by Anthony Rubio on 24/07/24.
//

import Foundation
import Combine

class MovieListViewModel: ObservableObject {
    @Published var movies: [MovieModel] = []
    @Published var selectedCategory: String = "popular"
    @Published var filters: MovieFiltersModel = MovieFiltersModel(adult: false, originalLanguage: .en,popularity: .desc)
    
    private let getMoviesUseCase: GetMoviesUseCase
    private var cancellables: Set<AnyCancellable> = []
    
    init(getMoviesUseCase: GetMoviesUseCase) {
        self.getMoviesUseCase = getMoviesUseCase
        
        $selectedCategory
            .combineLatest($filters)
            .sink { [weak self] (category, filters) in
                self?.filters = filters
                self?.selectedCategory = category
                self?.fetchMovies()
            }
            .store(in: &cancellables)
    }
    
    func fetchMovies() {
        getMoviesUseCase.execute(category: selectedCategory, page: 1, filters: filters)
            .sink(receiveCompletion: { completion in
                if case .failure(let error) = completion {
                    print("Error fetching movies: \(error)")
                }
            },
            receiveValue: { [weak self] movies in
                
                   self?.movies = movies.results
                
            })
            .store(in: &cancellables)
    }
    
    func discoverMovies() {
        getMoviesUseCase.execute(category: selectedCategory, page: 1, filters: filters)
            .sink(receiveCompletion: { completion in
                if case .failure(let error) = completion {
                    print("Error fetching movies: \(error)")
                }
            },
                  receiveValue: { [weak self] movies in
                
                self?.movies = movies.results
                
            })
            .store(in: &cancellables)
    }
    
}
