//
//  CompanySystem.swift
//  spm
//
//  Created by Joel Tavares on 06/06/25.
//

import SwiftUI
import SwiftDate
class CompanySystemViewModel: ObservableObject{
    @Published private var cinema: Cinema
        
    @Published var movies: [Cinema.Movie] = []{
        didSet{
            cinema = Cinema(id: 1, movies: movies)
        }
    }
    @Published var isLoading = false
    @Published var error: MovieError?
    
    private let movieService: MovieServiceProtocol
    
    init() {
        guard let apiKey = Bundle.main.infoDictionary?["MOVIE_SERVICE_API_KEY"] as? String, !apiKey.isEmpty else {
            fatalError("API key não encontrada")
        }
        self.movieService = MovieService(apiKey: apiKey)
        self.cinema = Cinema(id: 1, movies: [])
        self.movies = []
        
        Task { @MainActor in
            await loadData()
        }
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
    private var allGenres: [GenreDTO] = []
    
    private func loadGenres() async throws -> [GenreDTO]{
        if allGenres.isEmpty{
            allGenres = try await movieService.fetchGenres()
        }
        
        return allGenres
    }
    @MainActor
    func loadData() async {
        isLoading = true
        do {
            // 1. Busca filmes, gêneros e elenco em paralelo
            async let moviesTask = movieService.fetchUpcomingMovies()
            async let genresTask = loadGenres()
            
            let (movieDTOs, genres) = try await (moviesTask, genresTask)
            
            // 2. Para cada filme, busca o elenco
            var fullMovies: [Cinema.Movie] = []
            await withTaskGroup(of: Cinema.Movie?.self) { group in
                for movieDTO in movieDTOs {
                    group.addTask{
                        do{
                            let cast = try await self.movieService.fetchCast(movieId: movieDTO.id)
                            let photos = try await self.movieService.fetchPhotos(movieId: movieDTO.id)
                            
                            // 3. Mapeia genre_ids para objetos Genre
                            let movieGenres = genres.filter { genre in
                                movieDTO.genre_ids.contains(genre.id)
                            }.map { genre in
                                Cinema.Movie.Genre(id: genre.id, name: genre.name)
                            }
                            
                            // 4. Converte para o Model final
                            let movie = Cinema.Movie(
                                id: movieDTO.id,
                                voteAverage: movieDTO.vote_average,
                                title: movieDTO.title,
                                originalTitle: movieDTO.original_title,
                                popularity: movieDTO.popularity,
                                posterPath: "\(MovieConstants.imageUrl)\(movieDTO.poster_path ?? "")",
                                backdropPath: "\(MovieConstants.imageUrl)\(movieDTO.backdrop_path ?? "")",
                                overview: movieDTO.overview,
                                releaseDate: DateFormatter.yyyyMMdd.date(from: movieDTO.release_date) ?? Date(),
                                genres: movieGenres,
                                cast: cast.map { actor in
                                    Cinema.Movie.Actor(
                                        id: actor.id,
                                        name: actor.name,
                                        character: actor.character,
                                        profile_path: "\(MovieConstants.imageUrl)\(actor.profile_path ?? "")"
                                    )
                                },
                                photos: photos.map { mov in
                                    "\(MovieConstants.imageUrl)\(mov.file_path ?? "")"
                                } 
                            )
                            return movie
                        }catch{
                            return nil
                        }
                    }
                    
                    }
                for await movie in group {
                    if let movie = movie {
                        fullMovies.append(movie)
                    }
                }
                
            }
            self.movies = fullMovies
        } catch {
            self.error = error as? MovieError ?? .unknown
        }
        isLoading = false
    }
    
    private struct MovieConstants{
        static let imageUrl = "https://image.tmdb.org/t/p/w500"
    }
}


extension DateFormatter {
    static let yyyyMMdd: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()
}
