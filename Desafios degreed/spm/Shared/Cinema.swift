//
//  Cinema.swift
//  spm
//
//  Created by Joel Tavares on 06/06/25.
//

import Foundation
import SwiftDate
struct Cinema: Identifiable{
    let id: Int
    var movies : Array<Movie>
    
    struct Movie: Identifiable {
        static func releaseDateOrder (lhs: Cinema.Movie, rhs: Cinema.Movie) -> Bool{
            lhs.releaseDate > rhs.releaseDate
        }
        
        static func titleOrder (lhs: Cinema.Movie, rhs: Cinema.Movie) -> Bool{
            lhs.title < rhs.title
        }

        let id: Int
        var voteAverage: Double
        var title: String
        var originalTitle: String
        var popularity: Double
        var posterPath: String
        var backdropPath: String
        var overview: String
        var releaseDate: Date
        var genres: Array<Genre>
    
        struct Genre: Identifiable, Equatable{
            let id: Int
            var name: String
            
            static func == (lhs: Genre, rhs: Genre) -> Bool {
                return lhs.name == rhs.name
            }
        }
        
    }

}


//extension Cinema.Movie{
    
//}
