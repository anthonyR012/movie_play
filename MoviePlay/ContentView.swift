//
//  ContentView.swift
//  MoviePlay
//
//  Created by Anthony Rubio on 24/07/24.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = MovieListViewModel(getMoviesUseCase: GetMoviesUseCaseImpl(apiClient: APIClientImpl()))
    
    var body: some View {
        VStack {
            Picker("Select Category", selection: $viewModel.selectedCategory) {
                Text("Popular").tag("popular")
                Text("TopRated").tag("top_rated")
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding()
            
            MovieFilterView(filters: $viewModel.filters)
            List(viewModel.movies, id: \.self) { movie in
                VStack(alignment: .leading) {
                    Text(movie.title)
                        .font(.headline)
                    Text(movie.overview)
                        .font(.subheadline)
                }
            }
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
//
//#Preview {
//    ContentView()
//}
