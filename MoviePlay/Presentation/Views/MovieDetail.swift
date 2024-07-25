//
//  MovieDetail.swift
//  MoviePlay
//
//  Created by Anthony Rubio on 25/07/24.
//

import Foundation
import SwiftUI

struct MovieDetailView: View {
    let genres = ["action","infantil"]
    let movie : MovieModel
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                AsyncImage(url: URL(string: "https://image.tmdb.org/t/p/w500/\(movie.posterPath!)")) { phase in
                    if let image = phase.image {
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: .infinity, height: 326)
                    } else if phase.error != nil {
                        Text("Error al cargar la imagen")
                            .foregroundColor(.red)
                    } else {
                        ProgressView()
                    }
                }
                .frame(width: .infinity, height: 300)
                .cornerRadius(10)
                .ignoresSafeArea()
                
                
                
                VStack(alignment: .leading, spacing: 10) {
                    Text(movie.title)
                        .font(.largeTitle)
                        .bold()
                    
                    HStack {
                        Text("Release date:")
                            .font(.headline)
                        Text(movie.releaseDate)
                    }
                    
                    HStack {
                        Text("Genre:")
                            .font(.headline)
                        ForEach( genres, id: \.self) { genre in
                            Text(genre)
                                .padding(5)
                                .background(Color.gray.opacity(0.2))
                                .cornerRadius(5)
                        }
                    }
                    
                    Text("Synopsis")
                        .font(.headline)
                    Text(movie.overview)
                    
                    Text("Related Movies")
                        .font(.headline)
                    
                    
                }
                .padding()
            }
        }
        .navigationTitle(movie.title)
        .navigationBarTitleDisplayMode(.inline)
        
    }
}

