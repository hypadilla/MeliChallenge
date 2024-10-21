//
//  APIClientTests.swift
//  MeliChallenge
//
//  Created by Harold Padilla on 19/10/24.
//

import XCTest
@testable import MeliChallenge

class APIClientTests: XCTestCase {

    var apiClient: APIClient!

    override func setUp() {
        super.setUp()

        let config = URLSessionConfiguration.ephemeral
        config.protocolClasses = [MockURLProtocol.self]
        let session = URLSession(configuration: config)

        apiClient = APIClient(urlSession: session)
    }

    override func tearDown() {
        apiClient = nil
        MockURLProtocol.requestHandler = nil
        super.tearDown()
    }

    func testRequest_Success() {
        // Arrange
        let expectedData = "Test Data".data(using: .utf8)!
        MockURLProtocol.requestHandler = { request in
            XCTAssertEqual(request.url?.absoluteString, AppConstants.baseURL + "testEndpoint")
            let response = HTTPURLResponse(url: request.url!, statusCode: 200, httpVersion: nil, headerFields: nil)!
            return (response, expectedData)
        }
        let expectation = self.expectation(description: "Request Success")

        // Act
        _ = apiClient.request(endpoint: "testEndpoint") { result in
            // Assert
            switch result {
            case .success(let data):
                XCTAssertEqual(data, expectedData)
            case .failure(let error):
                XCTFail("Se esperaba éxito, pero ocurrió un error: \(error)")
            }
            expectation.fulfill()
        }

        waitForExpectations(timeout: 1, handler: nil)
    }

    func testRequest_Failure() {
        // Arrange
        let expectedError = NSError(domain: "Test", code: -1, userInfo: nil)
        MockURLProtocol.requestHandler = { _ in
            throw expectedError
        }
        let expectation = self.expectation(description: "Request Failure")

        // Act
        _ = apiClient.request(endpoint: "testEndpoint") { result in
            // Assert
            switch result {
            case .success:
                XCTFail("Se esperaba un error, pero se recibió éxito")
            case .failure(let error):
                if case APIError.networkError(let underlyingError) = error {
                    let nsError = underlyingError as NSError
                    XCTAssertEqual(nsError.domain, expectedError.domain)
                    XCTAssertEqual(nsError.code, expectedError.code)
                } else {
                    XCTFail("Se esperaba un APIError.networkError, pero se recibió: \(error)")
                }
            }
            expectation.fulfill()
        }

        waitForExpectations(timeout: 1, handler: nil)
    }
}
