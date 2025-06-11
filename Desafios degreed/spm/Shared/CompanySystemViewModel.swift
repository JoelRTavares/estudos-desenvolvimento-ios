//
//  CompanySystem.swift
//  spm
//
//  Created by Joel Tavares on 06/06/25.
//

import SwiftUI
import SwiftDate
class CompanySystemViewModel: ObservableObject{
    @Published private var cinema = createCinema()
    

    public var movies: Array<Cinema.Movie> {
        return cinema.movies
    }
    
    // MARK - Intents
    func searchByReleaseDateComparingNow(beforeNow: Bool) -> Array<Cinema.Movie>{
        cinema.movies.filter{ ($0.releaseDate <= Date()) == beforeNow }
    }
    
    
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
        var genre1 : Array<Cinema.Movie.Genre> = []
        genre1.append(Cinema.Movie.Genre(id: 1, name:  "drama"))
        
        var genre2 : Array<Cinema.Movie.Genre> = []
        genre2.append(Cinema.Movie.Genre(id: 1, name:  "Gospel"))
        genre2.append(Cinema.Movie.Genre(id: 1, name:  "Comedia"))
        
        var actors: Array<Cinema.Movie.Actor> = []
        actors.append(Cinema.Movie.Actor(id: 1, actorName: "Fulano de Tal", roleName: "Zé Jacaré"))
        actors.append(Cinema.Movie.Actor(id: 2, actorName: "Ciclno de Tal", roleName: "Jose Pereira"))
        actors.append(Cinema.Movie.Actor(id: 3, actorName: "Deutrano de Tal", roleName: "Zé Carlos"))
        
        var movies: Array<Cinema.Movie> = []
        movies.append(Cinema.Movie(id: 2, voteAverage: 4.1, title: "Exterminado", originalTitle: "The death", popularity: 3.7, posterPath: "forja", backdropPath: "outrolink.jpeg", overview: "Algum texto", releaseDate: Date() + 3.years, genres: genre1, cast: actors, duration:"2hr 10m", photos:["forja_background", "forja_background", "forja_background"]))
        
        movies.append(Cinema.Movie(id: 3, voteAverage: 2.1, title: "Anima", originalTitle: "Anima", popularity: 4.5, posterPath: "forja", backdropPath: "forja", overview: "Algum texto", releaseDate: Date() - 5.years, genres: genre1, cast: actors,duration:"2hr 5m", photos:["forja_background", "forja_background", "forja_background"]))
        
        movies.append(Cinema.Movie(id: 4 , voteAverage: 4.8, title: "A forja", originalTitle: "The Forge", popularity: 8.7, posterPath: "forja", backdropPath: "forja_background", overview: "A Forja - O Poder da Transformação é um filme dirigido por Alex Kendrick que narra a história de Isaiah Wright, um jovem de 19 anos que, após terminar o ensino médio, se sente perdido e sem rumo na vida. Criado por uma mãe solteira, ele passa seus dias jogando videogame e jogando basquete até que, pressionado por sua mãe, ele busca um emprego em uma grande empresa. Ao longo do filme, Isaiah é encorajado por sua mãe e um mentor devoto, explorando temas de fé, superação e propósito de vida.", releaseDate: Date(), genres: genre2, cast: actors, duration:"1hr 40m", photos:["forja_background", "forja_background", "forja_background"]))
        
        movies.append(Cinema.Movie(id: 5, voteAverage: 2.1, title: "Outro Filme", originalTitle: "Another Movie", popularity: 4.5, posterPath: "forja", backdropPath: "forja", overview: "Ipsum Lorem", releaseDate: Date() - 2.years, genres: genre1, cast: actors,duration:"1hr 35m", photos:["forja_background", "forja_background", "forja_background"]))
        return Cinema(id: 3, movies: movies)
    }
}
