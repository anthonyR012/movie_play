//
//  MovieDetail.swift
//  MoviePlay
//
//  Created by Anthony Rubio on 25/07/24.
//

import Foundation
import SwiftUI


struct MovieDetailView: View {
    let movie: MovieModel
    let genres : [GenreModel]

    var body: some View {
            VStack(alignment: .center) {
                HeaderDetailView(endPointImage: movie.posterPath)
                ContentDetailView(movie: movie,genres: genres)
            }
            .navigationTitle(movie.title)
            .navigationBarTitleDisplayMode(.inline)
        
    }
}

struct HeaderDetailView: View {
    var endPointImage: String?
    var body: some View {
        VStack{
            AsyncImage(url:
                        URL(string: "\(Configuration.shared.baseUrlImage)\(endPointImage!)"))
            { phase in
                if let image = phase.image {
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(height: 280) // Ajustar altura de la imagen
                        .clipped()
                    
                } else if phase.error != nil {
                    Image("NoFound")  .frame(width: 200, height: 200)
                        .foregroundStyle(.black)
                } else {
                    ProgressView()  .frame(width: 200, height: 200)
                        .foregroundStyle(.black)
                }
            }
            .frame( height: 100)
        }
        
    }
}

struct ContentDetailView: View {
    var movie: MovieModel
    let genres : [GenreModel]

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            VStack (alignment: .leading){
                Text(movie.title)
                    .font(.largeTitle)
                    .bold()
                    .foregroundStyle(.white)
                
                HStack {
                    Text("Release date:")
                        .font(.headline)
                    Text(movie.releaseDate)
                }.foregroundStyle(.white)
            }
            ScrollView (.horizontal,showsIndicators: false){
                HStack {
                    Text("Genre:")
                        .font(.headline)
                    ForEach(genres, id: \.self) { genre in
                        Text(genre.name)
                            .padding(6)
                            .background(Color.gray.opacity(0.2))
                            .cornerRadius(5)
                    }
                }
            }
           

            Text("Synopsis")
                .font(.headline)
            Text(movie.overview)
        }
        .padding()
    }
}
