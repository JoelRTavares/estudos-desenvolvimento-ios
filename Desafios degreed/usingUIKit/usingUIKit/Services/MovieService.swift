//
//  MovieService.swift
//  withUIKit
//
//  Created by Joel Tavares on 20/06/25.
//


import Foundation
import UIKit
protocol MovieServiceProtocol {
    func fetchUpcomingMovies(completion: @escaping (Result<[MovieDTO], MovieError>) -> Void)
    func fetchGenres(completion: @escaping (Result<[GenreDTO], MovieError>) -> Void)
    func fetchCast(movieId: Int, completion: @escaping (Result<[ActorDTO], MovieError>) -> Void)
    func fetchPhotos(movieId: Int, completion: @escaping (Result<[ImageDTO], MovieError>) -> Void)
}

final class MovieService: MovieServiceProtocol {
    private let apiKey: String
    private let baseURL = "https://api.themoviedb.org/3"
    private var session: URLSession
    
    init(apiKey: String) {
        self.apiKey = apiKey
        self.session = URLSession.shared
    }
    
    convenience init(apiKey: String, session: URLSession) {
        self.init(apiKey: apiKey)
        self.session = session
    }
    
    // 1. Requisição para filmes
    func fetchUpcomingMovies(completion: @escaping (Result<[MovieDTO], MovieError>) -> Void) {
        let endpoint = "\(baseURL)/movie/upcoming?api_key=\(apiKey)"
        
        performRequestSync(endpoint: endpoint) { result in
            switch result {
            case .failure(let error):
                // Chamando a closure de conclusão com o erro
                completion(.failure(error))
            case .success(let data):
                do {
                    let decoder = JSONDecoder()
                    decoder.keyDecodingStrategy = .convertFromSnakeCase
                    let response = try decoder.decode(MovieResponseDTO.self, from: data)
                    // Chamando a closure de conclusão com os filmes
                    completion(.success(response.results))
                } catch {
                    // Chamando a closure de conclusão com erro de decodificação
                    completion(.failure(error as? MovieError ?? MovieError.InvalidData))
                }
            }
        }
    }
    
    
    // 2. Requisição para gêneros
    func fetchGenres(completion: @escaping (Result<[GenreDTO], MovieError>) -> Void) {
        let endpoint = "\(baseURL)/genre/movie/list?api_key=\(apiKey)"
        
        performRequestSync(endpoint: endpoint) { result in
            switch result {
            case .failure(let error):
                completion(.failure(error))
            case .success(let data):
                do {
                    let decoder = JSONDecoder()
                    decoder.keyDecodingStrategy = .convertFromSnakeCase
                    
                    let response = try decoder.decode(GenreResponseDTO.self, from: data)
                    completion(.success(response.genres))
                } catch {
                    completion(.failure(error as? MovieError ?? MovieError.InvalidData))
                }
            }
        }
    }
    
    // 3. Requisição para elenco
    func fetchCast(movieId: Int, completion: @escaping (Result<[ActorDTO], MovieError>) -> Void){
        let endpoint = "\(baseURL)/movie/\(movieId)/credits?api_key=\(apiKey)"
        
        performRequestSync(endpoint: endpoint) { result in
            switch result {
            case .failure(let error):
                completion(.failure(error))
            case .success(let data):
                do {
                    let decoder = JSONDecoder()
                    decoder.keyDecodingStrategy = .convertFromSnakeCase
                    
                    let response = try decoder.decode(CastResponseDTO.self, from: data)
                    completion(.success(response.cast))
                } catch {
                    completion(.failure(error as? MovieError ?? MovieError.InvalidData))
                }
            }
        }
    }
    
    func fetchPhotos(movieId: Int, completion: @escaping (Result<[ImageDTO], MovieError>) -> Void) {
        let endpoint = "\(baseURL)/movie/\(movieId)/images?api_key=\(apiKey)"
        performRequestSync(endpoint: endpoint) { result in
            switch result {
            case .failure(let error):
                completion(.failure(error))
            case .success(let data):
                do {
                    let decoder = JSONDecoder()
                    decoder.keyDecodingStrategy = .convertFromSnakeCase
                    
                    let response = try decoder.decode(PhotosResponseDTO.self, from: data)
                    completion(.success(response.backdrops))
                } catch {
                    completion(.failure(error as? MovieError ?? MovieError.InvalidData))
                }
            }
        }
    }
    
    
    internal func performRequestSync(endpoint: String, completion: @escaping((Result<Data, MovieError>) -> Void)){
        guard let url = URL(string: endpoint) else { return completion(.failure(MovieError.InvalidUrl) )
        }
        
        session.dataTask(with: url) { (data, response, error) in
            if let error = error {
                return completion(.failure(error as? MovieError ?? MovieError.InvalidUrl))
            }
            guard let httpResponse = response as? HTTPURLResponse,
                  httpResponse.statusCode == 200 else {
                return completion(.failure(MovieError.InvalidResponse))
            }
            //print("Response code: \(httpResponse.statusCode)")
            if let data = data, !data.isEmpty {
                return completion(.success(data))
            }
            
            completion(.failure(MovieError.InvalidData))
            
        }.resume()
    }
}
