
//
//  MockMovieServiceTests.swift
//  usingUIKitTests
//
//  Created by Joel Rosa Tavares on 02/07/25.
//

import UIKit
@testable import usingUIKit
import XCTest

class MockURLProtocol: URLProtocol {
    static var mockData: Data?
    static var mockResponse: HTTPURLResponse?
    static var mockError: Error?

    override class func canInit(with request: URLRequest) -> Bool {
        return true
    }

    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }

    override func startLoading() {
        if let error = MockURLProtocol.mockError {
            client?.urlProtocol(self, didFailWithError: error)
        } else if let data = MockURLProtocol.mockData, let response = MockURLProtocol.mockResponse {
            client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
            client?.urlProtocol(self, didLoad: data)
            client?.urlProtocolDidFinishLoading(self)
        } else{
            if let response = MockURLProtocol.mockResponse {
                client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
            }
            client?.urlProtocolDidFinishLoading(self)
        }
    }

    override func stopLoading() {}
}


final class MockMovieServiceTests: XCTestCase {

    func testPerformRequestSync_InvalidURL() {
        let expectation = self.expectation(description: "Invalid URL Error")
        let invalidEndpoint = "ht^tp:/[url-malForm@tada]"
        let config = URLSessionConfiguration.default
        config.protocolClasses = [MockURLProtocol.self]
        let session = URLSession(configuration: config)
        let movieService = MovieService(apiKey: "any", session: session)

        movieService.performRequestSync(endpoint: invalidEndpoint) { result in
            switch result {
            case .success:
                XCTFail("Expected failure but got success")
            case .failure(let error):
                XCTAssertEqual(error, MovieError.InvalidUrl)
            }
            expectation.fulfill()
        }
        waitForExpectations(timeout: 10)
    }

    func testPerformRequestSync_InvalidResponse() {
        let expectation = self.expectation(description: "Invalid Response Error")

        // Configura o mock para retornar um código de status 400
        MockURLProtocol.mockResponse = HTTPURLResponse(url: URL(string: "https://example.com")!,
                                                       statusCode: 400,
                                                       httpVersion: nil,
                                                       headerFields: nil)
        MockURLProtocol.mockData = Data()
        MockURLProtocol.mockError = nil

        let config = URLSessionConfiguration.default
        config.protocolClasses = [MockURLProtocol.self]
        let session = URLSession(configuration: config)
        let movieService = MovieService(apiKey: "any", session: session)

        movieService.performRequestSync(endpoint: "https://example.com/validEndpoint") { result in
            switch result {
            case .success:
                XCTFail("Expected failure but got success")
            case .failure(let error):
                XCTAssertEqual(error, MovieError.InvalidResponse)
            }
            expectation.fulfill()
        }
        waitForExpectations(timeout: 10)
    }

    func testPerformRequestSync_InvalidData() {
        let expectation = self.expectation(description: "Invalid Data Error")

        MockURLProtocol.mockResponse = HTTPURLResponse(url: URL(string: "https://example.com")!,
                                                       statusCode: 200,
                                                       httpVersion: nil,
                                                       headerFields: nil)
        MockURLProtocol.mockData = nil

        MockURLProtocol.mockError = nil
        

        let config = URLSessionConfiguration.default
        config.protocolClasses = [MockURLProtocol.self]
        let session = URLSession(configuration: config)
        let movieService = MovieService(apiKey: "any", session: session)

        movieService.performRequestSync(endpoint: "https://example.com/correctEndpoint") { result in
            switch result {
            case .success:
                XCTFail("Expected failure but got success")
            case .failure(let error):
                XCTAssertEqual(error , MovieError.InvalidData)
            }
            expectation.fulfill()
        }
        waitForExpectations(timeout: 10)
    }
}
