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
        NavigationStack {
            VStack(alignment: .leading) {
                HeaderView(title: "Find Movies, Tv series, and more..")
                NavigationLink(destination: FilteredSearchView(viewModel: viewModel)) {
                    SearchBarView(searchText: .constant(""), isEnabled: false)
                }
                CategoryView(
                    categories: CategoryMovie.allCases,
                    selectedCategory: $viewModel.filters.category
                )
                MovieGridView(movies: viewModel.movies, genres: viewModel.genres)
            }
            .background(Color.black.edgesIgnoringSafeArea(.all))
        }
    }
}

struct HeaderView: View {
    let title: String

    var body: some View {
        Text(title)
            .font(.title)
            .bold()
            .foregroundColor(.white)
            .padding(.horizontal)
            .padding(.top, 20)
    }
}

struct SearchBarView: View {
    @Binding var searchText: String
    var isEnabled: Bool = true

    var body: some View {
        TextField("Search", text: $searchText)
            .padding(10)
            .disabled(!isEnabled)
            .background(Color(.systemGray6))
            .cornerRadius(10)
            .padding(.horizontal)
            .foregroundStyle(.black)
    }
}

struct CategoryView: View {
    let categories: [CategoryMovie]
    @Binding var selectedCategory: CategoryMovie

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack {
                ForEach(categories, id: \.self) { category in
                    Text(category.rawValue)
                        .foregroundColor(selectedCategory == category ? .orange : .white)
                        .padding(.vertical, 10)
                        .padding(.horizontal, 20)
                        .background(
                            Capsule()
                                .fill(selectedCategory == category ? Color.white.opacity(0.1) : Color.clear)
                        )
                        .scaleEffect(selectedCategory == category ? 1.1 : 1.0)
                        .animation(.easeInOut, value: selectedCategory)
                        .onTapGesture {
                            withAnimation {
                                selectedCategory = category
                            }
                        }
                }
            }
            .padding(.horizontal)
            .padding(.top, 10)
        }
    }
}

struct MovieGridView: View {
    let movies: [MovieModel]
    let genres: [GenreModel]

    var body: some View {
        ScrollView {
            LazyVGrid(columns: [GridItem(.adaptive(minimum: 150), spacing: 16)]) {
                ForEach(movies, id: \.self) { movie in
                    let movieGenres = genres.filter { movie.genreIDS.contains($0.id) }
                    MovieItemView(movie: movie, genres: movieGenres)
                }
            }
            .padding()
        }
    }
}

struct MovieItemView: View {
    let movie: MovieModel
    let genres: [GenreModel]

    var body: some View {
        NavigationLink(destination: MovieDetailView(movie: movie, genres: genres)) {
            VStack {
                let baseUrlImage = Configuration.shared.baseUrlImage
                let backdropPath = movie.backdropPath ?? ""
                AsyncImage(url: URL(string: "\(baseUrlImage)\(backdropPath)")) { phase in
                    switch phase {
                    case .empty:
                        Color.white.frame(width: 150, height: 200)
                    case let .success(image):
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 150, height: 200)
                            .clipped()
                            .cornerRadius(10)
                            .transition(.scale(scale: 0.5, anchor: .center))
                    case .failure:
                        Color.red
                            .frame(width: 150, height: 200)
                            .overlay(
                                VStack {
                                    Image(systemName: "exclamationmark.triangle")
                                        .foregroundColor(.white)
                                    Text("Failed to load image")
                                        .foregroundColor(.white)
                                        .font(.caption)
                                }
                            )
                    @unknown default:
                        EmptyView()
                    }
                }

                Text(movie.title)
                    .font(.caption)
                    .foregroundColor(.white)

                Text("(\(movie.releaseDate))")
                    .font(.caption)
                    .foregroundColor(.gray)
            }
        }
        .buttonStyle(PlainButtonStyle())
    }
}
