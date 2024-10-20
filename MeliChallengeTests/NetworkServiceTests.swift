//
//  NetworkServiceTests.swift
//  MeliChallengeTests
//
//  Created by Harold Padilla on 18/10/24.
//

import XCTest
@testable import MeliChallenge

class NetworkServiceTests: XCTestCase {

    var networkService: NetworkService!
    var mockAPIClient: MockAPIClient!

    override func setUp() {
        super.setUp()
        mockAPIClient = MockAPIClient()
        networkService = NetworkService(apiClient: mockAPIClient)
    }

    override func tearDown() {
        networkService = nil
        mockAPIClient = nil
        super.tearDown()
    }

    struct MockModel: Codable, Equatable {
        let id: String
        let name: String
        let value: Int
    }

    func testFetchData_Success() {
        // Arrange
        let mockObject = MockModel(id: "1", name: "Test", value: 42)
        let expectedData = try! JSONEncoder().encode(mockObject)
        mockAPIClient.result = .success(expectedData)
        let expectation = self.expectation(description: "FetchData Success")

        // Act
        networkService.fetchData(from: "testEndpoint", method: .GET, headers: nil, body: nil) { (result: Result<MockModel, Error>) in
            // Assert
            switch result {
            case .success(let response):
                XCTAssertEqual(response, mockObject)
            case .failure(let error):
                XCTFail("Se esperaba éxito, pero ocurrió un error: \(error)")
            }
            expectation.fulfill()
        }

        waitForExpectations(timeout: 1, handler: nil)
    }

    func testFetchData_Failure() {
        // Arrange
        let nsError = NSError(domain: "TestErrorDomain", code: -1009, userInfo: nil)
        let expectedError = APIError.networkError(nsError)
        mockAPIClient.result = .failure(expectedError)
        let expectation = self.expectation(description: "FetchData Failure")

        // Act
        networkService.fetchData(from: "testEndpoint", method: .GET, headers: nil, body: nil) { (result: Result<MockModel, Error>) in
            // Assert
            switch result {
            case .success:
                XCTFail("Se esperaba un error, pero se recibió éxito")
            case .failure(let error):
                if case APIError.networkError(let error as NSError) = error {
                    XCTAssertEqual(error.domain, nsError.domain)
                    XCTAssertEqual(error.code, nsError.code)
                } else {
                    XCTFail("Se esperaba APIError.networkError, pero se recibió: \(error)")
                }
            }
            expectation.fulfill()
        }

        waitForExpectations(timeout: 1, handler: nil)
    }

    func testFetchData_InvalidData() {
        // Arrange
        let invalidData = "Invalid Data".data(using: .utf8)!
        mockAPIClient.result = .success(invalidData)
        let expectation = self.expectation(description: "FetchData Invalid Data")

        // Act
        networkService.fetchData(from: "testEndpoint", method: .GET, headers: nil, body: nil) { (result: Result<MockModel, Error>) in
            // Assert
            switch result {
            case .success:
                XCTFail("Se esperaba un error de parsing, pero se recibió éxito")
            case .failure(let error):
                if case APIError.dataParsingError(let parsingError) = error {
                    XCTAssertTrue(parsingError is DecodingError)
                } else {
                    XCTFail("Se esperaba APIError.dataParsingError, pero se recibió: \(error)")
                }
            }
            expectation.fulfill()
        }

        waitForExpectations(timeout: 1, handler: nil)
    }
}
