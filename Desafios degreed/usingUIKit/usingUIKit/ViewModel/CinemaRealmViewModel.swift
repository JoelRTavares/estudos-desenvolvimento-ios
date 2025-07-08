//
//  CinemaRealmViewModel.swift
//  usingUIKit
//
//  Created by Joel Rosa Tavares on 08/07/25.
//

import Foundation
import UIKit
import RealmSwift


class CinemaRealmViewModel {
    let realm: Realm
    init() {
        self.realm = try! Realm()
    }
    func fetchAllMovies() -> [MovieRealm] {
        let movies = realm.objects(MovieRealm.self)
        return Array(movies)
    }
    
    @objc func writeNewMovie(_ movie: MovieRealm){
        do {
            try realm.write {
                if realm.object(ofType: MovieRealm.self, forPrimaryKey: movie.id) == nil {
                    realm.add(movie)
                } else {
                    print("Movie with id \(movie.id) already exists.")
                }
            }
        } catch {
            print("Error writing Movie with Realm: \(error)")
        }
    }
    
}
