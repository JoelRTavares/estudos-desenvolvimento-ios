//
//  CinemaRealm.swift
//  usingUIKit
//
//  Created by Joel Rosa Tavares on 08/07/25.
//

import Foundation
import RealmSwift

class MovieRealm: Object {
    convenience init(id: Int, name: String, releaseDate: String, rating: Double, firstGenre: String, posterPath: String){
        self.init()
        self.id = id
        self.name = name
        self.releaseDate = releaseDate
        self.rating = rating
        self.firstGenre = firstGenre
        self.posterPath = posterPath
    }
    
    
    @objc dynamic var id = 0
    @objc dynamic var name = ""
    @objc dynamic var releaseDate = ""
    @objc dynamic var rating = 0.0
    @objc dynamic var firstGenre = ""
    @objc dynamic var posterPath = ""
    
    override class func primaryKey() -> String? {
        return "id"
    }
}
