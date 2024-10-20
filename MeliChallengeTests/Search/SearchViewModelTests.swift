//
//  SearchViewModelTests.swift
//  MeliChallenge
//
//  Created by Harold Padilla on 19/10/24.
//

import XCTest
import Combine
@testable import MeliChallenge

class SearchViewModelTests: XCTestCase {
    var viewModel: SearchViewModelImp!
    var mockLoadSearchUseCase: MockLoadSearchUseCase!
    var state: PassthroughSubject<StateController, Never>!
    var cancellables: Set<AnyCancellable>!

    override func setUp() {
        super.setUp()
        mockLoadSearchUseCase = MockLoadSearchUseCase()
        state = PassthroughSubject<StateController, Never>()
        viewModel = SearchViewModelImp(state: state, loadSearchUseCase: mockLoadSearchUseCase)
        cancellables = []
    }

    override func tearDown() {
        viewModel = nil
        mockLoadSearchUseCase = nil
        state = nil
        cancellables = nil
        super.tearDown()
    }

    func testSearchSuccess() {
        // Arrange
        let expectedItems = [SearchItem(id: "1", title: "Test Item", price: 100.0, thumbnail: "http://example.com/image.jpg")]
        let expectedPaging = Paging(total: 1, primaryResults: 1, offset: 0, limit: 50)
        mockLoadSearchUseCase.result = .success((items: expectedItems, paging: expectedPaging))

        var states: [StateController] = []
        let expectation = self.expectation(description: "State is success")

        // Act
        state.sink { receivedState in
            states.append(receivedState)
            if receivedState == .success {
                expectation.fulfill()
            }
        }.store(in: &cancellables)

        viewModel.search(query: "Test")

        // Assert
        waitForExpectations(timeout: 1.0, handler: nil)
        XCTAssertEqual(states.first, .loading)
        XCTAssertEqual(states.last, .success)
    }

    func testSearchFailure() {
        // Arrange
        let expectedError = NSError(domain: "TestError", code: 0, userInfo: nil)
        mockLoadSearchUseCase.result = .failure(expectedError)

        var states: [StateController] = []
        let expectation = self.expectation(description: "State is fail")

        // Act
        state.sink { receivedState in
            states.append(receivedState)
            if case .fail(let errorMessage) = receivedState {
                XCTAssertTrue(errorMessage.contains(expectedError.localizedDescription))
                expectation.fulfill()
            }
        }.store(in: &cancellables)

        viewModel.search(query: "Test")

        // Assert
        waitForExpectations(timeout: 1.0, handler: nil)
        XCTAssertEqual(states.first, .loading)
        if case .fail(_) = states.last {
            // Success
        } else {
            XCTFail("Expected fail state")
        }
    }
}
