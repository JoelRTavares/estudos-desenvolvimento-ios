//
//  MovieServiceTests.swift
//  usingUIKitTests
//
//  Created by Joel Rosa Tavares on 01/07/25.
//
import UIKit
@testable import usingUIKit
import XCTest

final class MovieServiceTests: XCTestCase {

    var movieService: MovieService!
    var validMovieId: Int?
    override func setUp() {
        super.setUp()
        guard let apiKey = Bundle.main.infoDictionary?["MOVIE_SERVICE_API_KEY"] as? String, !apiKey.isEmpty else {
            fatalError("API key não encontrada")
        }
        
        movieService = MovieService(apiKey: apiKey)
        
    }
    
    override func tearDown() {
        movieService = nil
        validMovieId = nil
        super.tearDown()
    }
    
    func testFetchUpcomingMoviesSuccess() {
        let expectation = self.expectation(description: "Fetch upcoming movies success")
        
        movieService.fetchUpcomingMovies { result in
            switch result {
            case .success(let movies):
                XCTAssertNotNil(movies)
                XCTAssertTrue(movies.count > 0) 
            case .failure(let error):
                XCTFail("Expected success but got error: \(error)")
            }
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 10, handler: nil)
    }

    func testFetchUpcomingMoviesFailure() {
        let expectation = self.expectation(description: "Fetch upcoming movies failure")
        
        let invalidService = MovieService(apiKey: "chave_api_invalida")
        invalidService.fetchUpcomingMovies { result in
            switch result {
            case .success:
                XCTFail("Expected failure but got success")
            case .failure(let error):
                XCTAssertNotNil(error)
            }
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 10, handler: nil)
    }

    func testFetchGenresSuccess() {
        let expectation = self.expectation(description: "Fetch genres success")
        
        movieService.fetchGenres { result in
            switch result {
            case .success(let genres):
                XCTAssertNotNil(genres)
                XCTAssertTrue(genres.count > 0)
            case .failure(let error):
                XCTFail("Expected success but got error: \(error)")
            }
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 10, handler: nil)
    }

    func testFetchGenresFailure() {
        let expectation = self.expectation(description: "Fetch genres failure")
        
        // Simular falha com chave inválida
        let invalidService = MovieService(apiKey: "chave_api_invalida")
        invalidService.fetchGenres { result in
            switch result {
            case .success:
                XCTFail("Expected failure but got success")
            case .failure(let error):
                XCTAssertNotNil(error)
            }
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 10, handler: nil)
    }

    func testFetchCastSuccess() {
        let expectation = self.expectation(description: "Fetch cast success")
        
        // Primeiro, vamos buscar os filmes
        movieService.fetchUpcomingMovies { result in
            switch result {
            case .failure(let error):
                XCTFail("Expected sucess in fetchUpcomingMovies, but got error: \(error)")
                expectation.fulfill()
            case .success(let movies):
                XCTAssertNotNil(movies)
                XCTAssertTrue(movies.count > 0, "No movies in response.")
                
                // Obtendo o ID do primeiro filme
                guard let movieId = movies.first?.id else {
                    XCTFail("Movie ID is not avaliable.")
                    expectation.fulfill()
                    return
                }
                
                // Agora, podemos buscar o elenco do filme
                self.movieService.fetchCast(movieId: movieId) { result in
                    switch result {
                    case .success(let cast):
                        XCTAssertNotNil(cast)
                        XCTAssertTrue(cast.count > 0, "No actors in response.")
                    case .failure(let error):
                        XCTFail("Expect sucess, but got error: \(error)")
                    }
                    expectation.fulfill()
                }
            
            }
        }
        
        waitForExpectations(timeout: 10, handler: nil)
    }

    func testFetchCastFailure() {
        let expectation = self.expectation(description: "Fetch cast failure")
        
        // Simular falha com ID inválido
        movieService.fetchCast(movieId: -1) { result in
            switch result {
            case .success:
                XCTFail("Expected failure but got success")
            case .failure(let error):
                XCTAssertNotNil(error)
            }
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 10, handler: nil)
    }

    func testFetchPhotosSuccess() {
        let expectation = self.expectation(description: "Fetch photos success")
        
        
        movieService.fetchUpcomingMovies { result in
            switch result {
            case .failure(let error):
                XCTFail("Expected sucess in fetchUpcomingMovies, but got error: \(error)")
                expectation.fulfill()
            case .success(let movies):
                XCTAssertNotNil(movies)
                XCTAssertTrue(movies.count > 0, "No movies in response.")
                
                // Obtendo o ID do primeiro filme
                guard let movieId = movies.first?.id else {
                    XCTFail("Movie ID is not avaliable.")
                    expectation.fulfill()
                    return
                }
                self.movieService.fetchPhotos(movieId: movieId) { result in
                    switch result {
                    case .success(let photos):
                        XCTAssertNotNil(photos)
                        XCTAssertTrue(photos.count > 0)
                    case .failure(let error):
                        XCTFail("Expected success but got error: \(error)")
                    }
                    expectation.fulfill()
                }
            }
        }
        
        waitForExpectations(timeout: 10, handler: nil)
    }

    func testFetchPhotosFailure() {
        let expectation = self.expectation(description: "Fetch photos failure")
        
        movieService.fetchPhotos(movieId: -1) { result in
            switch result {
            case .success:
                XCTFail("Expected failure but got success")
            case .failure(let error):
                XCTAssertNotNil(error)
            }
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 10, handler: nil)
    }
}
