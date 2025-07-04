//
//  ViewModelTests.swift
//  usingUIKitTests
//
//  Created by Joel Rosa Tavares on 02/07/25.
//

import UIKit
@testable import usingUIKit
import XCTest
import SwiftDate

class MockMovieService: MovieServiceProtocol {
    var upcomingMoviesResult: Result<[MovieDTO], MovieError>?
    var genresResult: Result<[GenreDTO], MovieError>?
    var castResult: Result<[ActorDTO], MovieError>?
    var photosResult: Result<[ImageDTO], MovieError>?

    var fetchUpcomingMoviesCalled = false
    var fetchGenresCalled = false
    var fetchCastCalled = false
    var fetchPhotosCalled = false
    
    func fetchUpcomingMovies(completion: @escaping (Result<[MovieDTO], MovieError>) -> Void) {
        fetchUpcomingMoviesCalled = true
        if let result = upcomingMoviesResult {
            completion(result)
        }
    }

    func fetchGenres(completion: @escaping (Result<[GenreDTO], MovieError>) -> Void) {
        fetchGenresCalled = true
        if let result = genresResult {
            completion(result)
        }
    }

    func fetchCast(movieId: Int, completion: @escaping (Result<[ActorDTO], MovieError>) -> Void) {
        fetchCastCalled = true
        if let result = castResult {
            completion(result)
        }
    }

    func fetchPhotos(movieId: Int, completion: @escaping (Result<[ImageDTO], MovieError>) -> Void) {
        fetchPhotosCalled = true
        if let result = photosResult {
            completion(result)
        }
    }
}

class MockDelegate: CompanySystemViewModelDelegate {
    var moviesReceived: [Cinema.Movie]?
    var loadingStateChanged: Bool?
    var errorReceived: MovieError?
    
    func didUpdateMovies(_ movies: [Cinema.Movie]) {
        moviesReceived = movies
        loadingStateChanged = false
    }
    func didChangeLoadingState(isLoading: Bool) {
        loadingStateChanged = isLoading
    }
    func didReceiveError(_ error: MovieError) {
        errorReceived = error
    }
    func goToMovieDetails(_ movie: MovieCollectionViewCell) {}
}


final class ViewModelTests: XCTestCase {
    
    var viewModel: CompanySystemViewModel!
    var mockService: MockMovieService!

    override func setUp() {
        super.setUp()
        mockService = MockMovieService()
        viewModel = CompanySystemViewModel(movieService: mockService)
    }

    override func tearDown() {
        viewModel = nil
        mockService = nil
        super.tearDown()
    }
        
    @MainActor func testLoadDataSuccess() {
        let movieDTO = MovieDTO(id: 1, title: "Movie Title", originalTitle: "Original Title", voteAverage: 5.5, popularity: 8.0, posterPath: "logo", backdropPath: "logo", overview: "overview", releaseDate: "2020-01-01", genreIds: [1, 2])
        let genreDTO = GenreDTO(id: 1, name: "Action")
        let actorDTO = ActorDTO(id: 1, name: "Actor Name", character: "Main Character", profilePath: "/actor.jpg")
        let photoDTO = ImageDTO(filePath: "logo")
        
        mockService.upcomingMoviesResult = .success([movieDTO])
        mockService.genresResult = .success([genreDTO])
        mockService.castResult = .success([actorDTO])
        mockService.photosResult = .success([photoDTO])
        
        let expectation = self.expectation(description: "Movies loaded")

        
        let mockDelegate = MockDelegate()
        viewModel.delegate = mockDelegate
        
        viewModel.loadData()

        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 5.0)
        
        XCTAssertNotNil(mockDelegate.moviesReceived)
        XCTAssertEqual(mockDelegate.moviesReceived?.count, 1)
        XCTAssertEqual(mockDelegate.moviesReceived?.first?.title, "Movie Title")
        XCTAssertNil(mockDelegate.errorReceived)
        XCTAssertFalse(mockDelegate.loadingStateChanged ?? true)
        
        XCTAssertFalse(viewModel.movies.isEmpty)
    }

    @MainActor func testLoadDataError_fromMovie() {
        mockService.upcomingMoviesResult = .failure(MovieError.InvalidData)
        let expectation = self.expectation(description: "Error received")

        let mockDelegate = MockDelegate()
        viewModel.delegate = mockDelegate
        
        viewModel.loadData()

        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 5.0)

        XCTAssertNotNil(mockDelegate.errorReceived)
        XCTAssertTrue(mockService.fetchUpcomingMoviesCalled)
        //XCTAssertFalse(mockService.fetchGenresCalled)
        //Generos pode ser chamado, por conta dos filmes e eles sáo processados em paralelo.
        //Assim, os generos podem ser corretamente processados antes que os filmes gerem erro.
        XCTAssertFalse(mockService.fetchCastCalled)
        XCTAssertFalse(mockService.fetchPhotosCalled)
    }

    @MainActor func testLoadDataError_fromGenre() {
        let movieDTO = MovieDTO(id: 1, title: "Title", originalTitle: "Original", voteAverage: 5.5, popularity: 8.0, posterPath: "logo", backdropPath: "logo", overview: "over", releaseDate: "2020-01-01", genreIds: [1, 2])
        
        mockService.upcomingMoviesResult = .success([movieDTO])
        mockService.genresResult = .failure(MovieError.InvalidData)


        let expectation = self.expectation(description: "Error received")

        let mockDelegate = MockDelegate()
        viewModel.delegate = mockDelegate
        
        viewModel.loadData()

        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 5.0)

        XCTAssertNotNil(mockDelegate.errorReceived)
        XCTAssertTrue(mockService.fetchUpcomingMoviesCalled)
        XCTAssertTrue(mockService.fetchGenresCalled)

        XCTAssertFalse(mockService.fetchCastCalled)
        XCTAssertFalse(mockService.fetchPhotosCalled)
    }
    
    @MainActor func testLoadDataError_fromCast() {
        let movieDTO = MovieDTO(id: 1, title: "Title", originalTitle: "Original", voteAverage: 5.5, popularity: 8.0, posterPath: "logo", backdropPath: "logo", overview: "over", releaseDate: "2020-01-01", genreIds: [1, 2])
        let genreDTO = GenreDTO(id: 1, name: "Action")

        mockService.upcomingMoviesResult = .success([movieDTO])
        mockService.genresResult = .success([genreDTO])
        mockService.castResult = .failure(MovieError.InvalidData)

        let expectation = self.expectation(description: "Error received")

        let mockDelegate = MockDelegate()
        viewModel.delegate = mockDelegate
        
        viewModel.loadData()

        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 5.0)

        XCTAssertNotNil(mockDelegate.errorReceived)
        XCTAssertTrue(mockService.fetchUpcomingMoviesCalled)
        XCTAssertTrue(mockService.fetchGenresCalled)

        XCTAssertTrue(mockService.fetchCastCalled)
        XCTAssertTrue(mockService.fetchPhotosCalled)
        
        XCTAssertTrue(viewModel.movies.isEmpty)
    }
    @MainActor func testLoadDataError_fromPhotos() {
        let movieDTO = MovieDTO(id: 1, title: "Title", originalTitle: "Original", voteAverage: 5.5, popularity: 8.0, posterPath: "logo", backdropPath: "logo", overview: "over", releaseDate: "2020-01-01", genreIds: [1, 2])
        let genreDTO = GenreDTO(id: 1, name: "Action")
        let actorDTO = ActorDTO(id: 1, name: "Actor Name", character: "Main Character", profilePath: "/actor.jpg")

        mockService.upcomingMoviesResult = .success([movieDTO])
        mockService.genresResult = .success([genreDTO])
        mockService.castResult = .success([actorDTO])
        mockService.photosResult = .failure(MovieError.InvalidData)

        let expectation = self.expectation(description: "Error received")

        let mockDelegate = MockDelegate()
        viewModel.delegate = mockDelegate
        
        viewModel.loadData()

        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 5.0)

        XCTAssertNotNil(mockDelegate.errorReceived)
        XCTAssertTrue(mockService.fetchUpcomingMoviesCalled)
        XCTAssertTrue(mockService.fetchGenresCalled)

        XCTAssertTrue(mockService.fetchCastCalled)
        XCTAssertTrue(mockService.fetchPhotosCalled)
        
        XCTAssertTrue(viewModel.movies.isEmpty)
    }
    
    // MARK - Filtragem
    func testSearchMoviesByGenre() {
        let genreAction = Cinema.Movie.Genre(id: 1, name: "Action")
        let genreDrama = Cinema.Movie.Genre(id: 2, name: "Drama")
        
        let movie1 = Cinema.Movie(
            id: 1,
            voteAverage: 1.2,
            title: "Action Movie",
            originalTitle: "Action Movie",
            popularity: 1.2,
            posterPath: "logo",
            backdropPath: "logo",
            overview: "overview",
            releaseDate: Date(),
            genres: [genreAction],
            cast: [],
            photos: []
        )
        let movie2 = Cinema.Movie(
            id: 1,
            voteAverage: 1.2,
            title: "Drama Movie",
            originalTitle: "Drama Movie",
            popularity: 1.2,
            posterPath: "logo",
            backdropPath: "logo",
            overview: "overview",
            releaseDate: Date(),
            genres: [genreDrama],
            cast: [],
            photos: []
        )
        
        let testViewModel = CompanySystemViewModel([movie1, movie2])

        let filteredMovies = testViewModel.searchMoviesByGenre(genre: genreAction)
        
        XCTAssertEqual(filteredMovies.count, 1)
        XCTAssertEqual(filteredMovies.first?.title, "Action Movie")
    }
    
    func testSearchMoviesComparingNow() {
        
        let movie1 = Cinema.Movie(
            id: 1,
            voteAverage: 1.2,
            title: "Action Movie",
            originalTitle: "Action Movie",
            popularity: 1.2,
            posterPath: "logo",
            backdropPath: "logo",
            overview: "overview",
            releaseDate: Date() - 1.years,
            genres: [],
            cast: [],
            photos: []
        )
        let movie2 = Cinema.Movie(
            id: 1,
            voteAverage: 1.2,
            title: "Drama Movie",
            originalTitle: "Drama Movie",
            popularity: 1.2,
            posterPath: "logo",
            backdropPath: "logo",
            overview: "overview",
            releaseDate: Date() + 2.years,
            genres: [],
            cast: [],
            photos: []
        )
        
        let testViewModel = CompanySystemViewModel([movie1, movie2])

        let filteredMovies = testViewModel.searchByReleaseDateComparingNow(beforeNow: true)
        
        XCTAssertEqual(filteredMovies.count, 1)
        XCTAssertEqual(filteredMovies.first?.title, "Action Movie")
        
        let testViewModel2 = CompanySystemViewModel([movie1, movie2])

        let filteredMovies2 = testViewModel2.searchByReleaseDateComparingNow(beforeNow: false)
        
        XCTAssertEqual(filteredMovies2.count, 1)
        XCTAssertEqual(filteredMovies2.first?.title, "Drama Movie")
    }
    // MARK - ordenacao
    
    func testOrderingByReleaseDate() {
        
        let movie1 = Cinema.Movie(
            id: 1,
            voteAverage: 1.2,
            title: "2025",
            originalTitle: "Action Movie",
            popularity: 1.2,
            posterPath: "logo",
            backdropPath: "logo",
            overview: "overview",
            releaseDate: Date(),
            genres: [],
            cast: [],
            photos: []
        )
        let movie2 = Cinema.Movie(
            id: 1,
            voteAverage: 1.2,
            title: "2024",
            originalTitle: "Drama Movie",
            popularity: 1.2,
            posterPath: "logo",
            backdropPath: "logo",
            overview: "overview",
            releaseDate: Date() - 1.years,
            genres: [],
            cast: [],
            photos: []
        )
        let movie3 = Cinema.Movie(
            id: 1,
            voteAverage: 1.2,
            title: "2026",
            originalTitle: "Drama Movie",
            popularity: 1.2,
            posterPath: "logo",
            backdropPath: "logo",
            overview: "overview",
            releaseDate: Date() + 1.years,
            genres: [],
            cast: [],
            photos: []
        )
        
        let testViewModel = CompanySystemViewModel([movie1, movie2, movie3])

        let orderingMovies = testViewModel.orderByReleaseDate()
        
        XCTAssertEqual(orderingMovies.count, 3)
        XCTAssertEqual(orderingMovies[0].title, "2026")
        XCTAssertEqual(orderingMovies[1].title, "2025")
        XCTAssertEqual(orderingMovies[2].title, "2024")
    }
    
    func testOrderingByTitle() {
        
        let movie1 = Cinema.Movie(
            id: 1,
            voteAverage: 1.2,
            title: "B Movie",
            originalTitle: "Action Movie",
            popularity: 1.2,
            posterPath: "logo",
            backdropPath: "logo",
            overview: "overview",
            releaseDate: Date(),
            genres: [],
            cast: [],
            photos: []
        )
        let movie2 = Cinema.Movie(
            id: 1,
            voteAverage: 1.2,
            title: "C Movie",
            originalTitle: "Drama Movie",
            popularity: 1.2,
            posterPath: "logo",
            backdropPath: "logo",
            overview: "overview",
            releaseDate: Date() - 1.years,
            genres: [],
            cast: [],
            photos: []
        )
        let movie3 = Cinema.Movie(
            id: 1,
            voteAverage: 1.2,
            title: "A Movie",
            originalTitle: "Drama Movie",
            popularity: 1.2,
            posterPath: "logo",
            backdropPath: "logo",
            overview: "overview",
            releaseDate: Date() + 1.years,
            genres: [],
            cast: [],
            photos: []
        )
        
        let testViewModel = CompanySystemViewModel([movie1, movie2, movie3])

        let orderingMovies = testViewModel.orderByTitle()
        
        XCTAssertEqual(orderingMovies.count, 3)
        XCTAssertEqual(orderingMovies[0].title, "A Movie")
        XCTAssertEqual(orderingMovies[1].title, "B Movie")
        XCTAssertEqual(orderingMovies[2].title, "C Movie")
    }
}
