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
        XCTAssertTrue(ciandtLabel.waitForExistence(timeout: 10))
        
        app.images.element(boundBy: 1).tap()
        let backButton = app.buttons["Back"]
        XCTAssertTrue(backButton.waitForExistence(timeout: 10))
        
        backButton.tap()
        XCTAssertTrue(ciandtLabel.waitForExistence(timeout: 10))
    }
    
    @MainActor
    func testFirstNowAndUpcommingMovie() throws {
        let app = XCUIApplication()
        app.launch()
        
        let element = app.images.element(boundBy: 1)
        XCTAssertTrue(element.waitForExistence(timeout: 10))
        element.tap()
        let currentMovie = app.staticTexts["MovieTitleLabel"]
        XCTAssertTrue(currentMovie.waitForExistence(timeout: 10))
        let currentMovieTitle = currentMovie.label
        let backButton = app/*@START_MENU_TOKEN@*/.buttons["Back"]/*[[".navigationBars",".buttons.firstMatch",".buttons[\"Back\"]"],[[[-1,2],[-1,0,1]],[[-1,2],[-1,1]]],[0]]@END_MENU_TOKEN@*/
        XCTAssertTrue(backButton.waitForExistence(timeout: 5))
        backButton.tap()
        
        let upcomingMovies = app.staticTexts["Upcoming Movies"]
        XCTAssertTrue(upcomingMovies.waitForExistence(timeout:10))
        upcomingMovies.tap()
        XCTAssertTrue(element.waitForExistence(timeout: 10))
        element.tap()
        let upcomingMovieTitle = app.staticTexts["MovieTitleLabel"]
        
        XCTAssertTrue(upcomingMovieTitle.waitForExistence(timeout: 10))
        XCTAssertNotEqual(currentMovieTitle, upcomingMovieTitle.label)
        
        XCTAssertTrue(backButton.waitForExistence(timeout: 10))
        backButton.tap()
        
        let currentMovies = app.staticTexts["Current Movies"]
        XCTAssertTrue(currentMovies.waitForExistence(timeout: 10))
        currentMovies.tap()
    }
    
    @MainActor
    func testViewAllCast() throws {
        let app = XCUIApplication()
        app.launch()
        
        let element = app.images.element(boundBy: 1)
        XCTAssertTrue(element.waitForExistence(timeout: 10))
        element.tap()
        let currentMovie = app.staticTexts["MovieTitleLabel"]
        XCTAssertTrue(currentMovie.waitForExistence(timeout: 10))
        let currentMovieTitle = currentMovie.label
        
        let castSection = app.otherElements["Cast"]
        XCTAssertTrue(castSection.exists)
        let viewAllButton = castSection.buttons["View All"]
        
        XCTAssertTrue(viewAllButton.waitForExistence(timeout: 10))
        viewAllButton.tap()
        
        let castLabel = app.staticTexts["Cast & Crew"]
        XCTAssertTrue(castLabel.waitForExistence(timeout: 10))
        
        let returnButton = app.buttons[currentMovieTitle]
        XCTAssertTrue(returnButton.waitForExistence(timeout: 10))
        
        returnButton.tap()
        
        let backButton = app.buttons["Back"]
        XCTAssertTrue(backButton.waitForExistence(timeout: 10))
        
        backButton.tap()
        let ciandtLabel = app.staticTexts["CI&T Movies"]
        XCTAssertTrue(ciandtLabel.waitForExistence(timeout: 10))
    }
    
    @MainActor
    func testViewAllPhotos() throws {
        let app = XCUIApplication()
        app.launch()
        
        let element = app.images.element(boundBy: 1)
        XCTAssertTrue(element.waitForExistence(timeout: 10))
        element.tap()
        
        let photoSection = app.otherElements["Photos"]
        XCTAssertTrue(photoSection.exists)
        let viewAllButton = photoSection.buttons["View All"]
        
        XCTAssertTrue(viewAllButton.waitForExistence(timeout: 10))
        viewAllButton.tap()
        
        let photosLabel = app.staticTexts["Photos"]
        
        XCTAssertTrue(photosLabel.waitForExistence(timeout: 10))
    }
    
    @MainActor
    func testViewSynopsis() throws {
        let app = XCUIApplication()
        app.launch()
        var elementCount = 1
        
        while(true){
            let element = app.images.element(boundBy: elementCount)
            XCTAssertTrue(element.waitForExistence(timeout: 10))
            element.tap()
            
            let synopsisSection = app.staticTexts["SynopsisLabel"]
            XCTAssertTrue(synopsisSection.waitForExistence(timeout: 10))
            let currentSynopsis = synopsisSection.label
            
            let showMoreButton = app.buttons["Show more"]
            if(showMoreButton.waitForExistence(timeout: 1)){//Logica de apertar o botao, se ele existir
                showMoreButton.tap()
                
                XCTAssertNotEqual(synopsisSection.label, currentSynopsis)
                let showLessButton = app.buttons["Show less"]
                XCTAssertTrue(showLessButton.waitForExistence(timeout: 10))
                showLessButton.tap()
                XCTAssertEqual(synopsisSection.label, currentSynopsis)
                break
            }
            else{//Se nao existir, e porque e uma sinopse curta. Assim, ira retornar e visitar o proximo filme
                elementCount+=1
                let backButton = app.buttons["Back"]
                XCTAssertTrue(backButton.waitForExistence(timeout: 10))
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
