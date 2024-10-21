//
 //  ProductDetailViewModelTests.swift
 //  MeliChallenge
 //
 //  Created by Harold Padilla on 20/10/24.
 //
 
import XCTest
import Combine
@testable import MeliChallenge

class MockLoadProductDetailUseCase: LoadProductDetailUseCase {
    var result: Result<ProductDetail, Error>!
    
    func execute(productItemId: String) async throws -> Result<ProductDetail, Error> {
        return result
    }
}

class ProductDetailViewModelTests: XCTestCase {
    var viewModel: ProductDetailViewModelImp!
    var mockLoadProductDetailUseCase: MockLoadProductDetailUseCase!
    var state: PassthroughSubject<StateController, Never>!
    var cancellables: Set<AnyCancellable>!
    
    override func setUp() {
        super.setUp()
        mockLoadProductDetailUseCase = MockLoadProductDetailUseCase()
        state = PassthroughSubject<StateController, Never>()
        viewModel = ProductDetailViewModelImp(state: state, loadProductDetailUseCase: mockLoadProductDetailUseCase)
        cancellables = []
    }
    
    override func tearDown() {
        viewModel = nil
        mockLoadProductDetailUseCase = nil
        state = nil
        cancellables = nil
        super.tearDown()
    }
    
    func testLoadProductSuccess() {
        // Arrange
        let expectedProduct = ProductDetail(id: "1", title: "Test Product", price: 100.0, condition: "New", pictures: [Picture(secure_url: "http://example.com/image.jpg")])
        mockLoadProductDetailUseCase.result = .success(expectedProduct)
        
        var states: [StateController] = []
        let expectation = self.expectation(description: "State is success")
        
        // Act
        state.sink { receivedState in
            states.append(receivedState)
            if receivedState == .success {
                expectation.fulfill()
            }
        }.store(in: &cancellables)
        
        viewModel.loadProduct(productItemId: "1")
        
        // Assert
        waitForExpectations(timeout: 1.0, handler: nil)
        XCTAssertEqual(states.first, .loading)
        XCTAssertEqual(states.last, .success)
        XCTAssertEqual(viewModel.productDetail, expectedProduct)
    }
    
    func testLoadProductFailure() {
        // Arrange
        let expectedError = NSError(domain: "TestError", code: 0, userInfo: nil)
        mockLoadProductDetailUseCase.result = .failure(expectedError)
        
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
        
        viewModel.loadProduct(productItemId: "1")
        
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
