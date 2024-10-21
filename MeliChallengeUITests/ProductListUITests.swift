//
 //  ProductListUITests.swift
 //  MeliChallenge
 //
 //  Created by Harold Padilla on 20/10/24.
 //
 
import XCTest

class ProductListUITests: XCTestCase {

    var app: XCUIApplication!
    
    override func setUp() {
        continueAfterFailure = false

        app = XCUIApplication()
        app.launch()
        
        let searchBar = app.navigationBars.searchFields["Search on Mercado Libre"]
        searchBar.tap()
        searchBar.typeText("iPhone")
        app.keyboards.buttons["buscar"].tap()
        
        let firstCell = app.collectionViews.cells.element(boundBy: 0)
        XCTAssertTrue(firstCell.waitForExistence(timeout: 5), "First cell should exist after search")
    }
    
    override func tearDown() {
        app = nil
        super.tearDown()
    }
    
    func testProductListDisplaysItems() {
        let firstCell = app.collectionViews.cells.element(boundBy: 0)
        XCTAssertTrue(firstCell.exists, "First product item should exist")
        
        let secondCell = app.collectionViews.cells.element(boundBy: 1)
        XCTAssertTrue(secondCell.exists, "Second product item should exist")
    }
    
    func testScrollToLoadMoreProducts() {
        let collectionView = app.collectionViews.element(boundBy: 0)
        let initialCount = collectionView.cells.count
        
        let lastCell = collectionView.cells.element(boundBy: initialCount - 1)
        lastCell.swipeUp()
        
        let newCount = initialCount + 10
        let expectation = self.expectation(description: "Load more products")
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            XCTAssertTrue(collectionView.cells.count > initialCount, "More products should be loaded")
            expectation.fulfill()
        }
        waitForExpectations(timeout: 3, handler: nil)
    }
    
    func testSelectProductNavigatesToDetail() {
        let firstCell = app.collectionViews.cells.element(boundBy: 0)
        firstCell.tap()
        
        let productDetailTitle = app.staticTexts["new"]
        XCTAssertTrue(productDetailTitle.waitForExistence(timeout: 5), "Product detail should be displayed")
    }
}
