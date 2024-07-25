//
//  FilterView.swift
//  MoviePlay
//
//  Created by Anthony Rubio on 24/07/24.
//

import Foundation
import SwiftUI

struct FilterView : View {
    

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


    var body: some View{
        VStack {
            TextField("Search for movies", text: $viewModel.filters.query)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            Picker("Select Category", selection: $viewModel.filters.category) {
                Text("Popular").tag(CategoryMovie.popular)
                Text("TopRated").tag(CategoryMovie.topRated)
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

#Preview{
    FilterView()
}
