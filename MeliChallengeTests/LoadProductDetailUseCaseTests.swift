//
 //  LoadProductDetailUseCaseTests.swift
 //  MeliChallenge
 //
 //  Created by Harold Padilla on 20/10/24.
 //
 
import XCTest
@testable import MeliChallenge

class LoadProductDetailUseCaseTests: XCTestCase {
    var useCase: LoadProductDetailUseCaseImp!
    var repositoryMock: MockProductDetailRepository!
    
    override func setUp() {
        super.setUp()
        repositoryMock = MockProductDetailRepository()
        useCase = LoadProductDetailUseCaseImp(repository: repositoryMock)
    }
    
    override func tearDown() {
        useCase = nil
        repositoryMock = nil
        super.tearDown()
    }
    
    func testExecuteSuccess() async {
        // Arrange
        let expectedProduct = ProductDetail(id: "1", title: "Test Product", price: 100.0, condition: "New", pictures: [Picture(secure_url: "http://example.com/image.jpg")])
        repositoryMock.result = .success(expectedProduct)
        
        // Act
        do {
            let result = try await useCase.execute(productItemId: "1")
            
            // Assert
            switch result {
            case .success(let product):
                XCTAssertEqual(product, expectedProduct, "Returned product should match expected product")
            case .failure(let error):
                XCTFail("Expected success but got error: \(error)")
            }
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
            _ = try await useCase.execute(productItemId: "1")
            XCTFail("Expected failure but got success")
        } catch {
            // Assert
            XCTAssertEqual((error as NSError).domain, expectedError.domain, "Error domain should match")
            XCTAssertEqual((error as NSError).code, expectedError.code, "Error code should match")
        }
    }
}

// MARK: - Mock Classes

class MockProductDetailRepository: ProductDetailRepository {
    var result: Result<ProductDetail, Error>!
    
    func fetchProductDetailData(productItemId: String) async throws -> ProductDetail {
        switch result {
        case .success(let product):
            return product
        case .failure(let error):
            throw error
        case .none:
            return ProductDetail(id: "", title: "", price: 0.0, condition: "", pictures: [])
        }
    }
}
