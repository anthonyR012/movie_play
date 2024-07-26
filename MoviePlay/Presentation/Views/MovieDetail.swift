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
    let genres: [GenreModel]

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                MovieHeaderView(movie: movie)
                MovieOverviewView(movie: movie)
                MovieGenresView(genres: genres)
                MovieDetailsView(movie: movie)
            }
            .padding()
        }
        .navigationTitle(movie.title)
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct MovieHeaderView: View {
    let movie: MovieModel

    var body: some View {
        ZStack(alignment: .bottomLeading) {
            let baseUrlImage = Configuration.shared.baseUrlImage
            if let backdropPath = movie.backdropPath, let url = URL(string: "\(baseUrlImage)\(backdropPath)") {
                AsyncImage(url: url) { image in
                    image
                        .resizable()
                        .scaledToFit()
                } placeholder: {
                    ProgressView()
                }
            } else {
                Color.gray
            }

            Text(movie.title)
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(.white)
                .padding()
                .background(Color.black.opacity(0.7))
        }
    }
}

struct MovieOverviewView: View {
    let movie: MovieModel

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Overview")
                .font(.title2)
                .fontWeight(.bold)
            Text(movie.overview)
                .font(.body)
                .foregroundColor(.secondary)
        }
    }
}

struct MovieDetailsView: View {
    let movie: MovieModel

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Details")
                .font(.title2)
                .fontWeight(.bold)

            HStack {
                Text("Release Date:")
                    .fontWeight(.bold)
                Text(movie.releaseDate)
            }

            HStack {
                Text("Original Language:")
                    .fontWeight(.bold)
                Text(movie.originalLanguage)
            }

            HStack {
                Text("Vote Average:")
                    .fontWeight(.bold)
                Text("\(movie.voteAverage, specifier: "%.1f") (\(movie.voteCount) votes)")
            }

            HStack {
                Text("Popularity:")
                    .fontWeight(.bold)
                Text("\(movie.popularity, specifier: "%.1f")")
            }
        }
    }
}

struct MovieGenresView: View {
    let genres: [GenreModel]

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Genres")
                .font(.title2)
                .fontWeight(.bold)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 10) {
                    ForEach(genres, id: \.self) { genre in
                        Text(genre.name)
                            .font(.body)
                            .padding(.horizontal, 10)
                            .padding(.vertical, 5)
                            .background(Color.blue.opacity(0.2))
                            .cornerRadius(8)
                            .foregroundColor(.blue)
                    }
                }
            }
        }
    }
}
