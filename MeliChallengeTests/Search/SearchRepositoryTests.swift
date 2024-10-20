//
//  SearchRepositoryTests.swift
//  MeliChallenge
//
//  Created by Harold Padilla on 19/10/24.
//

import XCTest
@testable import MeliChallenge

class SearchRepositoryTests: XCTestCase {
    var repository: SearchRepositoryImp!
    var mockNetworkService: MockNetworkService!

    override func setUp() {
        super.setUp()
        mockNetworkService = MockNetworkService()
        repository = SearchRepositoryImp(networkService: mockNetworkService)
    }

    override func tearDown() {
        repository = nil
        mockNetworkService = nil
        super.tearDown()
    }

    func testFetchSearchDataSuccess() async {
        // Arrange
        let searchDTO = SearchDTO(id: "1", title: "Test Item", price: 100.0, thumbnail: "http://example.com/image.jpg")
        let responseDTO = SearchResponseDTO(results: [searchDTO], paging: PagingDTO(total: 1, primary_results: 1, offset: 0, limit: 50))
        mockNetworkService.result = .success(responseDTO)

        // Act
        do {
            let (items, paging) = try await repository.fetchSearchData(query: "Test", offset: 0, limit: 50)

            // Assert
            XCTAssertEqual(items.count, 1)
            XCTAssertEqual(items.first?.title, "Test Item")
            XCTAssertEqual(paging.total, 1)
        } catch {
            XCTFail("Expected success but got error: \(error)")
        }
    }

    func testFetchSearchDataFailure() async {
        // Arrange
        let expectedError = NSError(domain: "TestError", code: 0, userInfo: nil)
        mockNetworkService.result = .failure(expectedError)

        // Act
        do {
            _ = try await repository.fetchSearchData(query: "Test", offset: 0, limit: 50)
            XCTFail("Expected error but got success")
        } catch {
            // Assert
            XCTAssertEqual((error as NSError).domain, expectedError.domain)
        }
    }
}
