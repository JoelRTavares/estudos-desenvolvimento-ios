//
//  usingUIKitUITests.swift
//  usingUIKitUITests
//
//  Created by Joel Rosa Tavares on 24/06/25.
//

import XCTest

final class usingUIKitUITests: XCTestCase {

    override func setUpWithError() throws {
        continueAfterFailure = false
    }



    @MainActor
    func testGoAndDoBackOnMovie() throws {
        let app = XCUIApplication()
        app.launch()
        
        let ciandtLabel = app.staticTexts["CI&T Movies"]
        XCTAssertTrue(ciandtLabel.exists)
        
        app.images.element(boundBy: 1).tap()
        let backButton = app.buttons["Back"]
        XCTAssertTrue(backButton.exists)
        
        backButton.tap()
        XCTAssertTrue(ciandtLabel.exists)
    }
    
    @MainActor
    func testFirstNowAndUpcommingMovie() throws {
        let app = XCUIApplication()
        app.launch()
        
        let element = app.images.element(boundBy: 1)
        XCTAssertTrue(element.exists)
        element.tap()
        let currentMovie = app.staticTexts["MovieTitleLabel"]
        XCTAssertTrue(currentMovie.exists)
        let currentMovieTitle = currentMovie.label
        let backButton = app/*@START_MENU_TOKEN@*/.buttons["Back"]/*[[".navigationBars",".buttons.firstMatch",".buttons[\"Back\"]"],[[[-1,2],[-1,0,1]],[[-1,2],[-1,1]]],[0]]@END_MENU_TOKEN@*/
        XCTAssertTrue(backButton.exists)
        backButton.tap()
        
        let upcomingMovies = app.staticTexts["Upcoming Movies"]
        XCTAssertTrue(upcomingMovies.exists)
        upcomingMovies.tap()
        XCTAssertTrue(element.exists)
        element.tap()
        let upcomingMovieTitle = app.staticTexts["MovieTitleLabel"]
        
        XCTAssertTrue(upcomingMovieTitle.exists)
        XCTAssertNotEqual(currentMovieTitle, upcomingMovieTitle.label)
        
        XCTAssertTrue(backButton.exists)
        backButton.tap()
        
        let currentMovies = app.staticTexts["Current Movies"]
        XCTAssertTrue(currentMovies.exists)
        currentMovies.tap()
    }
    
    @MainActor
    func testViewAllCast() throws {
        let app = XCUIApplication()
        app.launch()
        
        let element = app.images.element(boundBy: 1)
        XCTAssertTrue(element.exists)
        element.tap()
        let currentMovie = app.staticTexts["MovieTitleLabel"]
        XCTAssertTrue(currentMovie.exists)
        let currentMovieTitle = currentMovie.label
        
        let castSection = app.otherElements["Cast"]
        XCTAssertTrue(castSection.exists)
        let viewAllButton = castSection.buttons["View All"]
        
        XCTAssertTrue(viewAllButton.exists)
        viewAllButton.tap()
        
        let castLabel = app.staticTexts["Cast & Crew"]
        XCTAssertTrue(castLabel.exists)
        
        let returnButton = app.buttons[currentMovieTitle]
        XCTAssertTrue(returnButton.exists)
        
        returnButton.tap()
        
        let backButton = app.buttons["Back"]
        XCTAssertTrue(backButton.exists)
        
        backButton.tap()
        let ciandtLabel = app.staticTexts["CI&T Movies"]
        XCTAssertTrue(ciandtLabel.exists)
    }
    
    @MainActor
    func testViewAllPhotos() throws {
        let app = XCUIApplication()
        app.launch()
        
        let element = app.images.element(boundBy: 1)
        XCTAssertTrue(element.exists)
        element.tap()
        
        let photoSection = app.otherElements["Photos"]
        XCTAssertTrue(photoSection.exists)
        let viewAllButton = photoSection.buttons["View All"]
        
        XCTAssertTrue(viewAllButton.exists)
        viewAllButton.tap()
        
        let photosLabel = app.staticTexts["Photos"]
        
        XCTAssertTrue(photosLabel.exists)
    }
    
    @MainActor
    func testViewSynopsis() throws {
        let app = XCUIApplication()
        app.launch()
        var elementCount = 1
        
        while(true){
            let element = app.images.element(boundBy: elementCount)
            XCTAssertTrue(element.exists)
            element.tap()
            
            let synopsisSection = app.staticTexts["SynopsisLabel"]
            XCTAssertTrue(synopsisSection.exists)
            let currentSynopsis = synopsisSection.label
            
            let showMoreButton = app.buttons["Show more"]
            if(showMoreButton.exists){//Logica de apertar o botao, se ele existir
                showMoreButton.tap()
                
                XCTAssertNotEqual(synopsisSection.label, currentSynopsis)
                let showLessButton = app.buttons["Show less"]
                XCTAssertTrue(showLessButton.exists)
                showLessButton.tap()
                XCTAssertEqual(synopsisSection.label, currentSynopsis)
                break
            }
            else{//Se nao existir, e porque e uma sinopse curta. Assim, ira retornar e visitar o proximo filme
                elementCount+=1
                let backButton = app.buttons["Back"]
                XCTAssertTrue(backButton.exists)
                backButton.tap()
            }
        }
    }
    

    @MainActor
    func testLaunchPerformance() throws {
        // This measures how long it takes to launch your application.
        measure(metrics: [XCTApplicationLaunchMetric()]) {
            XCUIApplication().launch()
            
        }
    }
}
