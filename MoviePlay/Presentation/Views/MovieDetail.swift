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

    var body: some View {
        GeometryReader { proxy in
            let size = proxy.size
            ScrollView {
                VStack(alignment: .leading) {
                    HeaderDetailView(endPointImage: movie.posterPath, width: size.width)
                    ContentDetailView(movie: movie)
                }
            }
            .navigationTitle(movie.title)
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

struct HeaderDetailView: View {
    var endPointImage: String?
    var width: CGFloat
    var body: some View {
        AsyncImage(url:
            URL(string: "\(Configuration.shared.baseUrlImage)\(endPointImage!)"))
        { phase in
            if let image = phase.image {
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: width, height: 300)
            } else if phase.error != nil {
                Text("Error al cargar la imagen")
                    .foregroundColor(.red)
            } else {
                ProgressView()
            }
        }
        .ignoresSafeArea()
    }
}

struct ContentDetailView: View {
    var movie: MovieModel
    let genres = ["action", "infantil"]

    var body: some View {
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
                ForEach(genres, id: \.self) { genre in
                    Text(genre)
                        .padding(5)
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(5)
                }
            }

            Text("Synopsis")
                .font(.headline)
            Text(movie.overview)
        }
        .padding()
    }
}
