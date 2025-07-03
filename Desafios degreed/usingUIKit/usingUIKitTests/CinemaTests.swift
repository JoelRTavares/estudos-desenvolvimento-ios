//
//  CinemaTests.swift
//  usingUIKitTests
//
//  Created by Joel Rosa Tavares on 03/07/25.
//

import XCTest
@testable import usingUIKit
import UIKit
import SwiftDate

final class CinemaTests: XCTestCase {
    func testReleaseOrder(){
        let movie1 = Cinema.Movie(id: 1, voteAverage: 1.1, title: "2024", originalTitle: "", popularity: 1.1, posterPath: "logo", backdropPath: "logo", overview: "over", releaseDate: Date() - 1.years, genres: [], cast: [], photos: [])
        
        let movie2 = Cinema.Movie(id: 1, voteAverage: 1.1, title: "2026", originalTitle: "", popularity: 1.1, posterPath: "logo", backdropPath: "logo", overview: "over", releaseDate: Date() + 1.years, genres: [], cast: [], photos: [])
        
        XCTAssertTrue(Cinema.Movie.releaseDateOrder(lhs: movie2, rhs: movie1))
        XCTAssertFalse(Cinema.Movie.releaseDateOrder(lhs: movie1, rhs: movie2))
    }
    
    func testTitleOrder(){
        let movie1 = Cinema.Movie(id: 1, voteAverage: 1.1, title: "AAAAAA", originalTitle: "", popularity: 1.1, posterPath: "logo", backdropPath: "logo", overview: "over", releaseDate: Date(), genres: [], cast: [], photos: [])
        
        let movie2 = Cinema.Movie(id: 1, voteAverage: 1.1, title: "ZZZZZZ", originalTitle: "", popularity: 1.1, posterPath: "logo", backdropPath: "logo", overview: "over", releaseDate: Date(), genres: [], cast: [], photos: [])
        
        XCTAssertTrue(Cinema.Movie.titleOrder(lhs: movie1, rhs: movie2))
        XCTAssertFalse(Cinema.Movie.titleOrder(lhs: movie2, rhs: movie1))
    }

    func testEquatableFromGenres() {
        let action1 = Cinema.Movie.Genre(id: 1, name: "Action")
        let action2 = Cinema.Movie.Genre(id: 2, name: "Action")
        let gospel = Cinema.Movie.Genre(id: 1, name: "Gospel")
        
        XCTAssertTrue(action1 == action2)
        XCTAssertFalse(action1 == gospel)
    }
}
