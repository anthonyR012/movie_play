//
//  FilterView.swift
//  MoviePlay
//
//  Created by Anthony Rubio on 24/07/24.
//

import Foundation
import SwiftUI

struct FilterView: View {
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
        VStack {
            SearchFilterView()
            MovieFilterView(filters: $viewModel.filters)
            ListMoviesFound(movies: viewModel.movies)
        }
    }
}

struct MovieFilterView: View {
    @Binding var filters: MovieFiltersModel

    var body: some View {
        VStack {
            Toggle("Adult Content", isOn: $filters.adult)
                .padding()

            Picker("Language", selection: $filters.originalLanguage) {
                Text("English").tag(OriginalLanguage.en)
                Text("French").tag(OriginalLanguage.fr)
                Text("Chinese").tag(OriginalLanguage.zh)
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding()

            HStack {
                Picker("Popularity", selection: $filters.popularity) {
                    Text("Ascending").tag(Popularity.asc)
                    Text("Descendant").tag(Popularity.desc)
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding()
            }
            .padding()
        }
    }
}

#Preview {
    FilterView()
}
//
struct ListMoviesFound: View {
    var movies : [MovieModel]
    var body: some View {
        GeometryReader{
            proxy in
            List(movies, id: \.self) { movie in
                VStack(alignment: .leading) {
                    NavigationLink(destination: MovieDetailView(movie: movie)) {
                        MovieCardView(movie: movie, width: proxy.size.width,
                        showSubTilte: false)
                    }
                    Text(movie.title)
                        .font(.headline)
                    Text(movie.overview)
                        .font(.subheadline)
                }
            }
        }
       
    }
}


//struct MovieListView: View {
//    let movies: [MovieModel]
//    let proxy: GeometryProxy
//    
//    @State private var selectedMovie: MovieModel? = nil
//    
//    var body: some View {
//        NavigationView {
//            List(movies, id: \.self) { movie in
//                Button(action: {
//                    // Establecer el estado para iniciar la navegación
//                    selectedMovie = movie
//                    navigateToMovieDetail(movie)
//                }) {
//                    HStack {
//                        MovieCardView(movie: movie, width: proxy.size.width, showSubTitle: false)
//                        VStack(alignment: .leading) {
//                            Text(movie.title)
//                                .font(.headline)
//                            Text(movie.overview)
//                                .font(.subheadline)
//                        }
//                    }
//                    .padding(.vertical, 8)
//                }
//                .buttonStyle(PlainButtonStyle())
//                .background(Color.clear)
//            }
//            .background(
//                NavigationLink(destination: MovieDetailView(movie: selectedMovie), isActive: Binding(
//                    get: { selectedMovie != nil },
//                    set: { if !$0 { selectedMovie = nil } }
//                )) {
//                    EmptyView()
//                }
//            )
//        }
//    }
//    
//    private func navigateToMovieDetail(_ movie: MovieModel) {
//        // Puedes realizar cualquier lógica adicional antes de navegar
//    }
//}
