//
//  HomeView.swift
//  MoviePlay
//
//  Created by Anthony Rubio on 25/07/24.
//

import Foundation
import SwiftUI

struct HomeView: View {
    @StateObject private var viewModel = MovieListViewModel(
        GetMoviesUseCaseImpl(
            apiClient: APIClientImpl(
                baseURL: Configuration.shared.baseUrl,
                token: Configuration.shared.token
            )))
    
    var body: some View {
        NavigationView {
            VStack {
                // Search bar
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.gray)
                    TextField("Sherlock Holmes", text: .constant(""))
                        .foregroundColor(.primary)
                }
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(10)
                .padding(.horizontal)
                .padding(.top)
                
                Picker("Select Category", selection:$viewModel.filters.category) {
                    Text(CategoryMovie.popular.rawValue).tag(CategoryMovie.popular)
                    Text(CategoryMovie.topRated.rawValue)
                        .tag(CategoryMovie.topRated)
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding(.horizontal)
                .padding(.top)
                
                Spacer()
                
                
               
                ScrollView {
                      LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 20) {
                          ForEach(viewModel.movies, id: \.self){
                              movie in
                              MovieCardView( movie: movie)
                          }
                          
                            
                        }
                        .padding()
                    
                    
                }
                // Movie grid
                
            }
            .navigationTitle("Find Movies, Tv series, and more.." )
            .labelStyle(DefaultLabelStyle())
            .background(Color("Background"))
        }
    }
}

struct MovieCardView: View {
    var movie: MovieModel
    
    var body: some View {
        VStack(alignment: .leading) {
            AsyncImage(url: URL(string: "https://image.tmdb.org/t/p/w500/\(movie.posterPath!)")) { phase in
                if let image = phase.image {
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 200, height: 300)
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
            Text("\(movie.title) (\(movie.releaseDate))")
                .font(.caption)
                .foregroundColor(.black)
                .lineLimit(1)
        }
    }
}


