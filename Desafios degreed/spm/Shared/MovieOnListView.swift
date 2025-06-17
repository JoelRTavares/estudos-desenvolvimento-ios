//
//  MovieOnListView.swift
//  spm
//
//  Created by Joel Tavares on 09/06/25.
//

import SwiftUI

struct MovieOnListView: View {
    @EnvironmentObject var themeVM: ThemeViewModel
    let movie : Cinema.Movie
    
    init(_ mov: Cinema.Movie){
        movie = mov
    }
    
    var body: some View {
        VStack(alignment: .leading){
            AsyncImage(url: URL(string: movie.posterPath))
            { phase in
                switch phase {
                case .empty:
                    ProgressView() 
                case .success(let image):
                    image
                        .resizable()
                        .aspectRatio(MovListConst.aspectRatio, contentMode: .fit)
                case .failure:
                    Image(systemName: MovListConst.defaultImage)
                        .resizable()
                        .aspectRatio(MovListConst.aspectRatio, contentMode: .fit)
                @unknown default:
                    EmptyView()
                }
            }
            
            Text("\(movie.title)")
                .bold()
                .font(.title)
            Text("\(movie.genres[0].name) • \(movie.releaseDate.toFormat(MovListConst.dateFormat)) | \(String(format: MovListConst.popularityFormat, movie.popularity))")
                .font(.title3)
        }
        .foregroundColor(themeVM.currentTheme.text)
    }
    
    private struct MovListConst{
        static let aspectRatio = 3.0/5
        static let dateFormat = "dd-MM-yyyy"
        static let popularityFormat = "%.1f"
        static let defaultImage = "photo"
    }
}

struct MovieOnListView_Previews: PreviewProvider {
    static var previews: some View {
        MovieOnListView(Cinema.Movie(id: 4 , voteAverage: 4.8, title: "A forja", originalTitle: "The Forge", popularity: 8.7, posterPath: "forja", backdropPath: "outrolink.jpeg", overview: "Algum texto", releaseDate: Date(), genres: [Cinema.Movie.Genre(id: 1, name: "Gospel")],cast: [Cinema.Movie.Actor(id: 1, name: "Clodo casto", character: "Juan")],  photos:["forja_background", "forja_background", "forja_background"]))
    }
}
