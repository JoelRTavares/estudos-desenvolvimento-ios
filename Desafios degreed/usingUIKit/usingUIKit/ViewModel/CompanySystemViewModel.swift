//
//  CompanySystemViewModel.swift
//  withUIKit
//
//  Created by Joel Tavares on 20/06/25.
//

import Foundation
import SwiftDate

protocol CompanySystemViewModelDelegate: AnyObject {
    func didUpdateMovies(_ movies: [Cinema.Movie])
    func didChangeLoadingState(isLoading: Bool)
    func didReceiveError(_ error: MovieError)
    func goToMovieDetails(_ movie: MovieCollectionViewCell)
}

class CompanySystemViewModel {
    
    weak var delegate: CompanySystemViewModelDelegate?
    
    private(set) var cinema: Cinema
    private(set) var movies: [Cinema.Movie] = [] {
        didSet {
            cinema = Cinema(id: 1, movies: movies)
            delegate?.didUpdateMovies(movies)
        }
    }
    
    private var isLoading: Bool = false {
        didSet {
            delegate?.didChangeLoadingState(isLoading: isLoading)
        }
    }
    
    @objc func goToMovieDetails(_ movie: MovieCollectionViewCell) {
        delegate?.goToMovieDetails(movie)
    }
    
    private var error: MovieError? {
        didSet {
            if let error = error {
                delegate?.didReceiveError(error)
            }
        }
    }
    
    
    private let movieService: MovieServiceProtocol
    private var allGenres: [GenreDTO] = []
    
    init(movieService: MovieServiceProtocol? = nil) {
        guard let apiKey = Bundle.main.infoDictionary?["MOVIE_SERVICE_API_KEY"] as? String, !apiKey.isEmpty else {
            fatalError("API key não encontrada")
        }
        self.movieService = movieService ?? MovieService(apiKey: apiKey)
        self.cinema = Cinema(id: 1, movies: [])
    }
    
    @MainActor
    func loadData() {
        isLoading = true
        
        Task {
            do {
                // 1. Buscar filmes e gêneros em paralelo
                async let moviesTask = movieService.fetchUpcomingMovies()
                async let genresTask = loadGenres()
                
                let (movieDTOs, genres) = try await (moviesTask, genresTask)
                
                // 2. Processar cada filme em paralelo
                let fullMovies: [Cinema.Movie] = await withTaskGroup(of: Cinema.Movie?.self) { group in
                    for movieDTO in movieDTOs {
                        group.addTask {
                            do {
                                let cast = try await self.movieService.fetchCast(movieId: movieDTO.id)
                                let photos = try await self.movieService.fetchPhotos(movieId: movieDTO.id)
                                
                                let movieGenres = genres
                                    .filter { movieDTO.genre_ids.contains($0.id) }
                                    .map { Cinema.Movie.Genre(id: $0.id, name: $0.name) }
                                
                                return Cinema.Movie(
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
                                    cast: cast.map {
                                        Cinema.Movie.Actor(
                                            id: $0.id,
                                            name: $0.name,
                                            character: $0.character,
                                            profile_path: "\(MovieConstants.imageUrl)\($0.profile_path ?? "")"
                                        )
                                    },
                                    photos: photos.map {
                                        "\(MovieConstants.imageUrl)\($0.file_path ?? "")"
                                    }
                                )
                            } catch {
                                return nil
                            }
                        }
                    }
                    
                    var result: [Cinema.Movie] = []
                    for await movie in group {
                        if let movie = movie {
                            result.append(movie)
                        }
                    }
                    return result
                }
                
                // 3. Atualizar estado principal com segurança
                await MainActor.run {
                    self.movies = fullMovies
                    self.cinema = Cinema(id: 1, movies: fullMovies)
                    self.isLoading = false
                }
                
            } catch {
                await MainActor.run {
                    self.error = error as? MovieError ?? .unknown
                    self.isLoading = false
                }
            }
        }
    }

    
    // MARK: - Helpers
    
    func searchByReleaseDateComparingNow(beforeNow: Bool) -> [Cinema.Movie] {
        cinema.movies.filter { ($0.releaseDate <= Date()) == beforeNow }
    }
    
    func searchMoviesByGenre(genre: Cinema.Movie.Genre) -> [Cinema.Movie] {
        cinema.movies.filter { $0.genres.contains(genre) }
    }
    
    func orderByReleaseDate() -> [Cinema.Movie] {
        cinema.movies.sorted(by: Cinema.Movie.releaseDateOrder)
    }
    
    func orderByTitle() -> [Cinema.Movie] {
        cinema.movies.sorted(by: Cinema.Movie.titleOrder)
    }
    
    private func loadGenres() async throws -> [GenreDTO] {
        if allGenres.isEmpty {
            allGenres = try await movieService.fetchGenres()
        }
        return allGenres
    }
    
    private struct MovieConstants {
        static let imageUrl = "https://image.tmdb.org/t/p/w500"
    }
}
