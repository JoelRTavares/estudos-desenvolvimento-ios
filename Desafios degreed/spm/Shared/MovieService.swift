//
//  MovieService.swift
//  spm
//
//  Created by Joel Tavares on 16/06/25.
//

import Foundation

protocol MovieServiceProtocol {
    func fetchUpcomingMovies() async throws -> [MovieDTO]
    func fetchGenres() async throws -> [GenreDTO]
    func fetchCast(movieId: Int) async throws -> [ActorDTO]
}

final class MovieService: MovieServiceProtocol {
    private let apiKey: String
    private let baseURL = "https://api.themoviedb.org/3"
    
    init(apiKey: String) {
        self.apiKey = apiKey
    }
    
    // 1. Requisição para filmes (agora retorna DTO, não o Model final)
    func fetchUpcomingMovies() async throws -> [MovieDTO] {
        let endpoint = "\(baseURL)/movie/upcoming?api_key=\(apiKey)"
        let data = try await performRequest(endpoint: endpoint)
        let response = try JSONDecoder().decode(MovieResponseDTO.self, from: data)
        return response.results
    }
    
    // 2. Requisição para gêneros
    func fetchGenres() async throws -> [GenreDTO] {
        let endpoint = "\(baseURL)/genre/movie/list?api_key=\(apiKey)"
        let data = try await performRequest(endpoint: endpoint)
        let response = try JSONDecoder().decode(GenreResponseDTO.self, from: data)
        return response.genres
    }
    
    // 3. Requisição para elenco
    func fetchCast(movieId: Int) async throws -> [ActorDTO] {
        let endpoint = "\(baseURL)/movie/\(movieId)/credits?api_key=\(apiKey)"
        let data = try await performRequest(endpoint: endpoint)
        let response = try JSONDecoder().decode(CastResponseDTO.self, from: data)
        return response.cast
    }
    
    // Método privado para evitar repetição de código
    private func performRequest(endpoint: String) async throws -> Data {
        guard let url = URL(string: endpoint) else { throw MovieError.InvalidUrl }
        let (data, response) = try await URLSession.shared.data(from: url)
        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200 else {
            throw MovieError.InvalidResponse
        }
        return data
    }
}
