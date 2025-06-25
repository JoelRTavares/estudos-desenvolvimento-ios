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
    let original_title: String
    let vote_average: Double
    let popularity: Double
    let poster_path: String?
    let backdrop_path: String?
    let overview: String
    let release_date: String
    let genre_ids: [Int]
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
    let profile_path: String?
}

struct PhotosResponseDTO: Decodable{
    let backdrops: [ImageDTO]
}

struct ImageDTO: Decodable {
    let file_path: String?
}
