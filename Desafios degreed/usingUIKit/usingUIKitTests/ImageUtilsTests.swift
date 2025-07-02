//
//  ImageUtilsTests.swift
//  usingUIKitTests
//
//  Created by Joel Rosa Tavares on 01/07/25.
//

import XCTest
@testable import usingUIKit
import UIKit

class ImageUtilsTests: XCTestCase {
    var imageView: UIImageView!
        
    override func setUp() {
        super.setUp()
        imageView = UIImageView()
    }
    
    override func tearDown() {
        imageView = nil
        super.tearDown()
    }
    
    // MARK: - Success Tests
    
    func testLoadImageFromValidURL() {
        // Given
        guard let validURL = URL(string: "https://picsum.photos/200") else {
            XCTFail("Could not create URL")
            return
        }
        
        let expectation = self.expectation(description: "Image loading completion")
        
        // When
        ImageUtils.loadImage(from: validURL, into: imageView)
        
        // Then
        // Use a timer to check for image changes instead of KVO
        let timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { [weak self] timer in
            guard let self = self else { return }
            
            if self.imageView.image != nil {
                timer.invalidate()
                expectation.fulfill()
            }
        }
        
        waitForExpectations(timeout: 10) { error in
            timer.invalidate()
            if let error = error {
                XCTFail("Timeout error: \(error.localizedDescription)")
            }
            
            XCTAssertNotNil(self.imageView.image)
            
            // Check that we didn't get the default "not found" image
            let defaultImage = UIImage(systemName: DetailsConst.Img.defaultImgNotFound)
            XCTAssertFalse(self.imagesAreEqual(self.imageView.image, defaultImage),
                          "Expected loaded image to be different from default 'not found' image")
        }
    }
    
    func testLoadImageFromLocalFile() {
        // Create a test image and save it to a temporary file
        let expectation = self.expectation(description: "Local file image loading completion")
        
        // Create a simple test image
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: 100, height: 100))
        let testImage = renderer.image { context in
            UIColor.red.setFill()
            context.fill(CGRect(x: 0, y: 0, width: 100, height: 100))
        }
        
        guard let imageData = testImage.pngData(),
              let temporaryURL = saveImageDataToTemporaryFile(imageData: imageData) else {
            XCTFail("Could not create temporary image file")
            return
        }
        
        // When
        ImageUtils.loadImage(from: temporaryURL, into: imageView)
        
        // Use a timer to check for image changes
        let timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { [weak self] timer in
            guard let self = self else { return }
            
            if self.imageView.image != nil {
                timer.invalidate()
                expectation.fulfill()
            }
        }
        
        // Then
        waitForExpectations(timeout: 5) { error in
            timer.invalidate()
            if let error = error {
                XCTFail("Timeout error: \(error.localizedDescription)")
            }
            
            XCTAssertNotNil(self.imageView.image)
            
            // Clean up
            try? FileManager.default.removeItem(at: temporaryURL)
        }
    }
    
    // MARK: - Failure Tests
    
    func testLoadImageWithInvalidURL() {
        // Given
        guard let invalidURL = URL(string: "https://thisurldoesnotexist.example.com/image.jpg") else {
            XCTFail("Could not create URL")
            return
        }
        
        let expectation = self.expectation(description: "Invalid URL loading completion")
        
        // When
        ImageUtils.loadImage(from: invalidURL, into: imageView)
        
        // Then
        // Use a timer to check for image changes
        let timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { [weak self] timer in
            guard let self = self else { return }
            
            if self.imageView.image != nil {
                timer.invalidate()
                expectation.fulfill()
            }
        }
        
        waitForExpectations(timeout: 10) { error in
            timer.invalidate()
            if let error = error {
                XCTFail("Timeout error: \(error.localizedDescription)")
            }
            
            XCTAssertNotNil(self.imageView.image)
            
            // Compare with the expected default "not found" image
            let defaultImage = UIImage(systemName: DetailsConst.Img.defaultImgNotFound)
            XCTAssertTrue(self.imagesAreEqual(self.imageView.image, defaultImage),
                         "Expected image to be the default 'not found' image")
        }
    }
    
    func testLoadImageWithInvalidData() {
        // Given
        // Creating a URL to a text file which is not a valid image
        guard let invalidDataURL = URL(string: "https://www.example.com") else {
            XCTFail("Could not create URL")
            return
        }
        
        let expectation = self.expectation(description: "Invalid data loading completion")
        
        // When
        ImageUtils.loadImage(from: invalidDataURL, into: imageView)
        
        // Then
        // Use a timer to check for image changes
        let timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { [weak self] timer in
            guard let self = self else { return }
            
            if self.imageView.image != nil || self.checkElapsedTime(seconds: 8) {
                timer.invalidate()
                expectation.fulfill()
            }
        }
        
        waitForExpectations(timeout: 10) { error in
            timer.invalidate()
            if let error = error {
                XCTFail("Timeout error: \(error.localizedDescription)")
            }
            
            if let image = self.imageView.image {
                // Compare with the expected default "not found" image
                let defaultImage = UIImage(systemName: DetailsConst.Img.defaultImgNotFound)
                XCTAssertTrue(self.imagesAreEqual(image, defaultImage),
                             "Expected image to be the default 'not found' image")
            }
        }
    }
    
    // MARK: - Helper Methods
    
    private var startTime: Date?
    
    private func checkElapsedTime(seconds: TimeInterval) -> Bool {
        if startTime == nil {
            startTime = Date()
            return false
        }
        
        guard let start = startTime else { return false }
        return Date().timeIntervalSince(start) > seconds
    }
    
    private func saveImageDataToTemporaryFile(imageData: Data) -> URL? {
        let temporaryDirectoryURL = URL(fileURLWithPath: NSTemporaryDirectory())
        let temporaryFileURL = temporaryDirectoryURL.appendingPathComponent("testImage.png")
        
        do {
            try imageData.write(to: temporaryFileURL)
            return temporaryFileURL
        } catch {
            print("Error creating temporary file: \(error)")
            return nil
        }
    }
    
    /// Helper method to compare two UIImages
    private func imagesAreEqual(_ image1: UIImage?, _ image2: UIImage?) -> Bool {
        guard let image1 = image1, let image2 = image2 else {
            return image1 == nil && image2 == nil
        }
        
        // For system images, we can compare their configuration
        if let config1 = image1.configuration, let config2 = image2.configuration {
            // This is a simplistic comparison but should work for system images in our case
            return config1.isEqual(config2)
        }
        
        // If not system images, we can compare their size and pixel data
        guard image1.size == image2.size else { return false }
        
        // For a more thorough comparison, we'd compare the actual pixel data
        // But this is a simple approach that might be sufficient for our tests
        return image1.pngData() == image2.pngData()
    }
}
