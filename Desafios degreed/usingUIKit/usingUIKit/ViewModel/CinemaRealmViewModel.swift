//
//  CinemaRealmViewModel.swift
//  usingUIKit
//
//  Created by Joel Rosa Tavares on 08/07/25.
//

import Foundation
import UIKit
import RealmSwift


protocol CinemaRealmViewModelDelegate: AnyObject {
    func didDetectDuplicateMovie(movieName: String)
    func confirmSuccessfulOperation(movieName: String)
    //func confirmSuccessfulDelete(movieName: String)
    func gotError(err: any Error)
}

class CinemaRealmViewModel {
    weak var delegate: CinemaRealmViewModelDelegate?
    let realm: Realm
    
    
    init() {
        self.realm = try! Realm()
    }
    func fetchAllMovies() -> [MovieRealm] {
        let movies = realm.objects(MovieRealm.self)
        return Array(movies)
    }
    
    func writeNewMovie(_ movie: MovieRealm){
        do {
            try realm.write {
                if realm.object(ofType: MovieRealm.self, forPrimaryKey: movie.id) == nil {
                    realm.add(movie)
                    delegate?.confirmSuccessfulOperation(movieName: movie.name)
                } else {
                    delegate?.didDetectDuplicateMovie(movieName: movie.name)
                    //print("Movie with id \(movie.id) already exists.")
                }
            }
        } catch {
            delegate?.gotError(err: error)
            //print("Error writing Movie with Realm: \(error)")
        }
    }
    
    func updateMovieIfExists(_ movie: MovieRealm){
        do {
            try realm.write {
                if let existingMovie = realm.object(ofType: MovieRealm.self, forPrimaryKey: movie.id) {
                    let movieName = existingMovie.name
                    existingMovie.name = movie.name
                    existingMovie.releaseDate = movie.releaseDate
                    existingMovie.firstGenre = movie.firstGenre
                    existingMovie.rating = movie.rating

                    delegate?.confirmSuccessfulOperation(movieName: movieName)
                } else {
                    delegate?.didDetectDuplicateMovie(movieName: movie.name)
                    //print("Movie with id \(movie.id) dont exists.")
                }
            }
        } catch {
            delegate?.gotError(err: error)
            //print("Error writing Movie with Realm: \(error)")
        }
    }
    
    func deleteNewMovie(_ movie: MovieRealm){
        do {
            try realm.write {
                if let existingMovie = realm.object(ofType: MovieRealm.self, forPrimaryKey: movie.id) {
                    let movieName = existingMovie.name
                    realm.delete(existingMovie)
                    delegate?.confirmSuccessfulOperation(movieName: movieName)
                } else {
                    delegate?.didDetectDuplicateMovie(movieName: movie.name)
                    //print("Movie with id \(movie.id) dont exists.")
                }
            }
        } catch {
            delegate?.gotError(err: error)
            //print("Error writing Movie with Realm: \(error)")
        }
    }
    
}
