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
            Image("\(movie.posterPath)")
                .resizable()
                .aspectRatio(3/5, contentMode: .fit)
            
            Text("\(movie.title)")
                .bold()
                .font(.title)
            Text("\(movie.genres[0].name) • \(movie.releaseDate.toFormat("dd-MM-yyyy")) | \(String(format: "%.1f",movie.popularity))")
                .font(.title3)
        }
        .foregroundColor(themeVM.currentTheme.text)
        
    }
}

struct MovieOnListView_Previews: PreviewProvider {
    static var previews: some View {
        MovieOnListView(Cinema.Movie(id: 4 , voteAverage: 4.8, title: "A forja", originalTitle: "The Forge", popularity: 8.7, posterPath: "forja", backdropPath: "outrolink.jpeg", overview: "Algum texto", releaseDate: Date(), genres: [Cinema.Movie.Genre(id: 1, name: "Gospel")],cast: [Cinema.Movie.Actor(id: 1, actorName: "Clodo casto", roleName: "Juan")], duration: "1hr 49m", photos:["forja_background", "forja_background", "forja_background"]))
    }
}
