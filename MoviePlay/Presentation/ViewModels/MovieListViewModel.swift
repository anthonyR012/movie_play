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
    @Published var genres: [GenreModel] = []
    @Published var filters: MovieFiltersModel = MovieFiltersModel(
        adult: false,
        originalLanguage: .en,
        popularity: .desc,
        category: .popular,
        page: 1,
        query: "",
        typeFilter: .all)
    
    private let getMoviesUseCase: GetMoviesUseCase
    private let getGenresUseCase: GetGenresUseCase
    private var cancellables: Set<AnyCancellable> = []
    
    init(_ getMoviesUseCase: GetMoviesUseCase,_  getGenresUseCase: GetGenresUseCase) {
        self.getMoviesUseCase = getMoviesUseCase
        self.getGenresUseCase = getGenresUseCase
        $filters
            .map { $0.language } 
            .sink { [weak self] language in
                self?.fetchGenders(for: language)
            }
            .store(in: &cancellables)
        $filters
            .sink { [weak self] filters in
                self?.fetchMovies(filters: filters)
            }
            .store(in: &cancellables)
    }
    
    
    func fetchMovies(filters: MovieFiltersModel) {
        getMoviesUseCase.execute( filters: filters)
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
    
   func fetchGenders(for lenguage: String) {
        getGenresUseCase.execute(lenguage: lenguage)
            .sink(receiveCompletion: { completion in
                if case .failure(let error) = completion {
                    print("Error fetching genres: \(error)")
                }
            },
            receiveValue: { [weak self] genres in
                   self?.genres = genres.genres
            })
            .store(in: &cancellables)
    }
    
}
