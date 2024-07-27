import SwiftUI

struct FilteredSearchView: View {
    @ObservedObject var viewModel: MovieListViewModel

    var body: some View {
        VStack(alignment: .leading) {
            SearchBarView(searchText: $viewModel.filters.query)
            MovieFilterView(filters: $viewModel.filters)
            FilteredResult(movies: viewModel.movies, genres: viewModel.genres)
        }
        .background(Color.black.edgesIgnoringSafeArea(.all))
        .foregroundColor(.white)
    }
}

struct MovieFilterView: View {
    @Binding var filters: MovieFiltersModel

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Picker("Language", selection: $filters.originalLanguage) {
                ForEach(OriginalLanguage.allCases, id: \.self) { language in
                    Text(language.rawValue).tag(language)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            Toggle("Include Adult Content", isOn: $filters.adult)
                .foregroundStyle(.black)
                .tint(.black)
        }
        .padding()
        .background(Color(.white))
        .cornerRadius(10)
        .padding(.horizontal)
        .transition(.slide)
    }
}

struct FilteredResult: View {
    var movies: [MovieModel]
    var genres: [GenreModel]

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
