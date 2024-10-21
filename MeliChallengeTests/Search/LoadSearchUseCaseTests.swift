//
//  LoadSearchUseCaseTests.swift
//  MeliChallenge
//
//  Created by Harold Padilla on 19/10/24.
//

import XCTest
@testable import MeliChallenge

class LoadSearchUseCaseTests: XCTestCase {
    var useCase: LoadSearchUseCaseImp!
    var repositoryMock: MockSearchRepository!

    override func setUp() {
        super.setUp()
        repositoryMock = MockSearchRepository()
        useCase = LoadSearchUseCaseImp(repository: repositoryMock)
    }

    override func tearDown() {
        useCase = nil
        repositoryMock = nil
        super.tearDown()
    }

    func testExecuteSuccess() async {
        // Arrange
        let expectedItems = [SearchItem(id: "1", title: "Test Item", price: 100.0, thumbnail: "http://example.com/image.jpg")]
        let expectedPaging = Paging(total: 1, primaryResults: 1, offset: 0, limit: 50)
        repositoryMock.result = .success((items: expectedItems, paging: expectedPaging))

        // Act
        do {
            let (items, paging) = try await useCase.execute(query: "Test", offset: 0, limit: 50)

            // Assert
            XCTAssertEqual(items.count, expectedItems.count)
            XCTAssertEqual(items.first?.title, expectedItems.first?.title)
            XCTAssertEqual(paging.total, expectedPaging.total)
            XCTAssertEqual(paging.offset, expectedPaging.offset)
            XCTAssertEqual(paging.limit, expectedPaging.limit)
        } catch {
            XCTFail("Expected success but got error: \(error)")
        }
    }

    func testExecuteFailure() async {
        // Arrange
        let expectedError = NSError(domain: "TestError", code: 0, userInfo: nil)
        repositoryMock.result = .failure(expectedError)

        // Act
        do {
            _ = try await useCase.execute(query: "Test", offset: 0, limit: 50)
            XCTFail("Expected error but got success")
        } catch {
            // Assert
            XCTAssertEqual((error as NSError).domain, expectedError.domain)
            XCTAssertEqual((error as NSError).code, expectedError.code)
        }
    }
}
