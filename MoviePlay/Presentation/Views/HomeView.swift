//
//  HomeView.swift
//  MoviePlay
//
//  Created by Anthony Rubio on 25/07/24.
//

import Foundation
import SwiftUI

struct HomeView: View {
    @StateObject private var viewModel: MovieListViewModel

    init() {
        let apiClient = APIClientDatasourceImpl(
            baseURL: Configuration.shared.baseUrl,
            token: Configuration.shared.token
        )
        let getMoviesUseCase = GetMoviesUseCaseImpl(apiClient: apiClient)
        let getGenresUseCase = GetGenresUseCaseImpl(apiClient: apiClient)
        _viewModel = StateObject(wrappedValue: MovieListViewModel(getMoviesUseCase, getGenresUseCase))
    }

    var body: some View {
        NavigationView {
            VStack {
                NavigationLink(destination: FilterView()) {
                    SearchFilterView(query: $viewModel.filters.query ,enable: false)
                }
                CategoryFilter(category: $viewModel.filters.category)
                Spacer()
                ListMoviesScrollView(movies: $viewModel.movies,genres: viewModel.genres)
            }
            .navigationTitle("Find Movies and More..")
            .labelStyle(DefaultLabelStyle())
        }
    }
}

struct MovieCardView: View {
    var movie: MovieModel
    var width: CGFloat
    var showSubTilte: Bool = true

    var body: some View {
        VStack(alignment: .center) {
            AsyncImage(url: URL(string: "\(Configuration.shared.baseUrlImage)\(movie.posterPath!)")) { phase in
                if let image = phase.image {
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: width, height: 300)
                } else if phase.error != nil {
                    Text("Error al cargar la imagen")
                        .foregroundColor(.red)
                } else {
                    ProgressView()
                }
            }
            .frame(width: 220, height: 326)
            .cornerRadius(10)
            .padding()
            if showSubTilte {
                Text("\(movie.title) (\(movie.releaseDate))")
                    .font(.caption)
                    .foregroundColor(.black)
                    .lineLimit(1)
            }
            
        }
    }
}


struct SearchFilterView: View {
    @Binding var query : String
    var enable : Bool = true
    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.gray)
            TextField("Sherlock Holmes", text: enable ? $query : .constant(""))
                .foregroundStyle(.primary)
                .disabled(!enable)
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(10)
        .padding(.horizontal)
        .padding(.top)
    }
}

struct ListMoviesScrollView: View {
    @Binding var movies: [MovieModel]
    let genres: [GenreModel]
    var body: some View {
        GeometryReader { proxy in
            ScrollView {
                LazyVGrid(columns: [GridItem(.flexible()),

                                    GridItem(.flexible())], spacing: 20)
                {
                    ForEach(movies, id: \.self) {
                        movie in
                        let movieGenres = genres.filter { movie.genreIDS.contains($0.id) }
                        NavigationLink(destination: MovieDetailView(movie: movie,genres: movieGenres)) {
                            MovieCardView(movie: movie,
                                          width: proxy.size.width * 0.5)
                        }
                    }
                }
                .padding()
            }
        }
    }
}

struct CategoryFilter: View {
    @Binding var category: CategoryMovie
    var body: some View {
        Picker("Select Category", selection: $category) {
            Text(CategoryMovie.popular.rawValue).tag(CategoryMovie.popular)
            Text(CategoryMovie.topRated.rawValue)
                .tag(CategoryMovie.topRated)
        }
        .pickerStyle(SegmentedPickerStyle())
        .padding(.horizontal)
        .accentColor(.blue)
        .padding(.top)
    }
}
