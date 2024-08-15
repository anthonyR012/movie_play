//
//  HomeView.swift
//  MoviePlay
//
//  Created by Anthony Rubio on 25/07/24.
//

import Foundation
import Kingfisher
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
    @FocusState var isFocused: Bool

    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(isFocused ? .orange : .gray)
            TextField("Sherlock Holmes", text: $searchText)
                .foregroundColor(.primary)
        }
        .padding()
        .background(Color(.systemGray6))
        .focused($isFocused)
        .cornerRadius(10)
        .padding(.horizontal)
        .padding(.top)
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
        }.transition(.move(edge: .bottom))
            .animation(.spring(response: 0.6, dampingFraction: 0.8, blendDuration: 0),
                       value: UUID())
    }
}

struct MovieItemView: View {
    let movie: MovieModel
    let genres: [GenreModel]
    private let baseUrlImage = Configuration.shared.baseUrlImage
    var body: some View {
        NavigationLink(destination: MovieDetailView(movie: movie, genres: genres)) {
            VStack {
                let backdropPath = movie.backdropPath ?? ""
                KFImage(URL(string: "\(baseUrlImage)\(backdropPath)"))
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 150, height: 200)
                    .clipped()
                    .cornerRadius(10)

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

#Preview {
    HomeView()
}
