//
//  CompanySystem.swift
//  spm
//
//  Created by Joel Tavares on 06/06/25.
//

import SwiftUI
import SwiftDate
class CompanySystem: ObservableObject{
    @Published private var cinema = createCinema()
    

    public var movies: Array<Cinema.Movie> {
        return cinema.movies
    }
    
    // MARK - Intents
    
    func searchMoviesByGenre(genre: Cinema.Movie.Genre) -> Array<Cinema.Movie>{
        cinema.movies.filter {$0.genres.contains(genre)}
    }
    
    func orderByReleaseDate() -> Array<Cinema.Movie>{
        cinema.movies.sorted(by: Cinema.Movie.releaseDateOrder)
    }
    
    func orderByTitle() -> Array<Cinema.Movie>{
        cinema.movies.sorted(by: Cinema.Movie.titleOrder)
    }
    //Ordem alfabetica
    
    private static func createCinema() -> Cinema{
        var genre1 : Array<Cinema.Movie.Genre> = [] //Populando o array de filmes
        genre1.append(Cinema.Movie.Genre(id: 1, name:  "drama"))
        
        var genre2 : Array<Cinema.Movie.Genre> = []
        genre2.append(Cinema.Movie.Genre(id: 1, name:  "comedia"))
        
        var movies: Array<Cinema.Movie> = []
        movies.append(Cinema.Movie(id: 2, voteAverage: 4.1, title: "Exterminado", originalTitle: "The death", popularity: 3.7, posterPath: "https://algumlink.png", backdropPath: "outrolink.jpeg", overview: "Algum texto", releaseDate: Date() - 3.years, genres: genre1))
        
        movies.append(Cinema.Movie(id: 3, voteAverage: 2.1, title: "Anima", originalTitle: "Anima", popularity: 4.5, posterPath: "https://algumlink.png", backdropPath: "outrolink.jpeg", overview: "Algum texto", releaseDate: Date() - 5.years, genres: genre1))
        
        movies.append(Cinema.Movie(id: 4 , voteAverage: 4.8, title: "El Novato", originalTitle: "The rookie", popularity: 4.7, posterPath: "https://algumlink.png", backdropPath: "outrolink.jpeg", overview: "Algum texto", releaseDate: Date() - 6.months, genres: genre2))
        return Cinema(id: 3, movies: movies)
    }
}
