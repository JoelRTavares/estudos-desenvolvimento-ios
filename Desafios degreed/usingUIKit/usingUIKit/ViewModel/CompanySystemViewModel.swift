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
    
    private(set) var movies: [Cinema.Movie] = [] {
        didSet {
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
    }
    
    convenience init (_ mov: [Cinema.Movie]){
        self.init()
        movies = mov
    }
    
    @MainActor
    func loadData() {
        isLoading = true

        // Crie uma DispatchGroup
        let queue = DispatchQueue.global()
        let dispatchGroup = DispatchGroup()

        // Variáveis para armazenar resultados
        var movieDTOs: [MovieDTO] = []
        var error: MovieError?

        // Primeiro, buscar filmes
        dispatchGroup.enter()
        queue.async(group: dispatchGroup) { [weak self] in
            guard let self = self else { return }
            
            self.movieService.fetchUpcomingMovies { result in
                switch result {
                case .failure(let error):
                    self.error = error
                    print("Erro ao buscar filmes: \(error)")
                    dispatchGroup.leave()
                case .success(let movies):
                    movieDTOs = movies
                    print("Fim do carregamento de filmes")
                    dispatchGroup.leave()
                }
            }
        }
        
        // Então, buscar gêneros
        dispatchGroup.enter()
        queue.async(group: dispatchGroup) { [weak self] in
            guard let self = self else { return }
            
          self.loadGenres(){ result in
                switch result {
                case .failure(let error):
                    self.error = error
                    print("Erro ao buscar genres: \(error)")
                    dispatchGroup.leave()
                case .success(let genr):
                    self.allGenres = genr
                    print("Fim do carregamento de generos")
                    dispatchGroup.leave()
                }
            }
        }

        // Aguarde até que todas as tarefas sejam concluídas
        dispatchGroup.notify(queue: .main) { [weak self] in
            guard let self = self else { return }
            
            if self.error != nil {
                self.isLoading = false
                print(self.error ?? MovieError.unknown)
                return
            }

            var fullMovies: [Cinema.Movie] = []
            let processingQueue = DispatchQueue.global()
            let processingGroup = DispatchGroup()

            // Processar cada filme
            for movieDTO in movieDTOs {
                
                processingGroup.enter()
                
                processingQueue.async(group: processingGroup) {
                    let innerQueue = DispatchQueue.global()
                    let innerQueueGroup = DispatchGroup()
                    
                    var cast: [Cinema.Movie.Actor] = []
                    var photos: [String] = []
                    
                    innerQueueGroup.enter()
                    innerQueue.async(group: innerQueueGroup){[weak self] in
                        guard let self = self else { return }
                        self.movieService.fetchCast(movieId: movieDTO.id) { result in
                            switch result {
                            case .success(let cas):
                                cast = self.convertCastDTOIntoEntities(cas)
                                innerQueueGroup.leave()
                            case .failure(let error):
                                self.error = error
                                print("Erro ao carregar elenco: \(error)")
                                innerQueueGroup.leave()
                            }
                        }
                    }
                    
                    innerQueueGroup.enter()
                    innerQueue.async(group: innerQueueGroup) {
                        self.movieService.fetchPhotos(movieId: movieDTO.id) { result in
                            switch result {
                            case .success(let photosDTO):
                                photos = self.convertImageDTOIntoStrings(photosDTO)
                                innerQueueGroup.leave()
                            case .failure(let error):
                                self.error = error
                                print("Erro ao carregar fotos: \(error)")
                                innerQueueGroup.leave()
                            }
                        }
                    }
                    
                    
                    
                    var movieGenres = [Cinema.Movie.Genre]()
                    innerQueueGroup.enter()
                    innerQueue.async(group: innerQueueGroup) {
                        movieGenres = self.allGenres.filter { movieDTO.genreIds.contains($0.id) }
                            .map { Cinema.Movie.Genre(id: $0.id, name: $0.name) }
                        innerQueueGroup.leave()
                    }
                    
                    innerQueueGroup.notify(queue: .global(qos: .userInitiated)) {
                        if self.error != nil {
                            self.isLoading = false
                            print(self.error ?? MovieError.unknown)
                            processingGroup.leave()
                            return
                        }
                        
                        let cinemaMovie = self.defineMovieWithEntities(movieDTO: movieDTO, genres: movieGenres, cast: cast, photos: photos)

                        fullMovies.append(cinemaMovie)
                        processingGroup.leave()
                    }
                    
                }
            }

            // Aguarde até que todos os filmes tenham sido processados
            processingGroup.notify(queue: .main) { [weak self] in
                guard let self = self else { return }
                
                self.movies = fullMovies
                self.isLoading = false
            }
        }
    }
    
    private func convertCastDTOIntoEntities(_ cast: [ActorDTO]) -> [Cinema.Movie.Actor] {
        cast.map {
            Cinema.Movie.Actor(
                id: $0.id,
                name: $0.name,
                character: $0.character,
                profilePath: $0.profilePath != nil ? "\(MovieConstants.imageUrl)\($0.profilePath ?? "")" : nil
            )
        }
    }
    private func convertImageDTOIntoStrings(_ images: [ImageDTO]) -> [String]{
        images.map {"\(MovieConstants.imageUrl)\($0.filePath ?? "")"}
    }
    private func defineMovieWithEntities(movieDTO: MovieDTO, genres: [Cinema.Movie.Genre], cast: [Cinema.Movie.Actor], photos: [String]) -> Cinema.Movie {
        Cinema.Movie(
            id: movieDTO.id,
            voteAverage: movieDTO.voteAverage,
            title: movieDTO.title,
            originalTitle: movieDTO.originalTitle,
            popularity: movieDTO.popularity,
            posterPath: "\(MovieConstants.imageUrl)\(movieDTO.posterPath ?? "")",
            backdropPath: "\(MovieConstants.imageUrl)\(movieDTO.backdropPath ?? "")",
            overview: movieDTO.overview,
            releaseDate: DateFormatter.yyyyMMdd.date(from: movieDTO.releaseDate) ?? Date(),
            genres: genres,
            cast: cast,
            photos: photos
        )
    }
    
    // MARK: - Helpers
    func searchByReleaseDateComparingNow(beforeNow: Bool) -> [Cinema.Movie] {
        movies.filter { ($0.releaseDate <= Date()) == beforeNow }
    }
    
    func searchMoviesByGenre(genre: Cinema.Movie.Genre) -> [Cinema.Movie] {
        movies.filter { $0.genres.contains(genre) }
    }
    
    func orderByReleaseDate() -> [Cinema.Movie] {
        movies.sorted(by: Cinema.Movie.releaseDateOrder)
    }
    
    func orderByTitle() -> [Cinema.Movie] {
        movies.sorted(by: Cinema.Movie.titleOrder)
    }
    
    private func loadGenres(completion: @escaping (Result<[GenreDTO], MovieError>) -> Void) {
        if allGenres.isEmpty {
            self.movieService.fetchGenres { result in
                switch result {
                case .failure(let error):
                    print("Erro ao buscar filmes: \(error)")
                    completion(.failure(MovieError.InvalidData))
                case .success(let genr):
                    completion(.success(genr))
                }
            }
        } else{
            completion(.success(self.allGenres))
        }
    }
    
    private struct MovieConstants {
        static let imageUrl = "https://image.tmdb.org/t/p/w500"
    }
}
