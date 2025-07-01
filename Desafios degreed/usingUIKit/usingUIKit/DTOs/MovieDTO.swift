//
//  MovieDTO.swift
//  withUIKit
//
//  Created by Joel Tavares on 20/06/25.
//

import Foundation

// Modelos temporários (DTOs) para a API
struct MovieResponseDTO: Decodable {
    let results: [MovieDTO]
}

struct MovieDTO: Decodable {
    let id: Int
    let title: String
    let originalTitle: String//Converter para camelCase
    let voteAverage: Double
    let popularity: Double
    let posterPath: String?
    let backdropPath: String?
    let overview: String
    let releaseDate: String
    let genreIds: [Int]
}

struct GenreResponseDTO: Decodable {
    let genres: [GenreDTO]
}

struct GenreDTO: Decodable {
    let id: Int
    let name: String
}

struct CastResponseDTO: Decodable {
    let cast: [ActorDTO]
}

struct ActorDTO: Decodable {
    let id: Int
    let name: String
    let character: String
    let profilePath: String?
}

struct PhotosResponseDTO: Decodable{
    let backdrops: [ImageDTO]
}

struct ImageDTO: Decodable {
    let filePath: String?
}
