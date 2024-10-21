//
 //  ProductDetailUITests.swift
 //  MeliChallenge
 //
 //  Created by Harold Padilla on 20/10/24.
 //
 
import XCTest

class ProductDetailUITests: XCTestCase {

    var app: XCUIApplication!
    
    override func setUp() {
        continueAfterFailure = false

        app = XCUIApplication()
        app.launch()
        
        // Perform a search to navigate to ProductDetail
        let searchBar = app.navigationBars.searchFields["Search on Mercado Libre"]
        searchBar.tap()
        searchBar.typeText("iPhone")
        app.keyboards.buttons["buscar"].tap()
        
        // Wait for search results
        let firstCell = app.collectionViews.cells.element(boundBy: 0)
        XCTAssertTrue(firstCell.waitForExistence(timeout: 5), "First cell should exist after search")
        firstCell.tap()
    }
    
    override func tearDown() {
        app = nil
        super.tearDown()
    }
    
    func testProductDetailDisplaysCorrectInfo() {
        let condition = app.staticTexts["new"]
        XCTAssertTrue(condition.waitForExistence(timeout: 5), "Product condition should be displayed")
    }
    
    func testBackNavigationFromProductDetail() {
        let backButton = app.navigationBars.buttons["Product List"]
        XCTAssertTrue(backButton.exists, "Back button should exist")
        backButton.tap()
        app.navigationBars.buttons.element(boundBy: 0).tap()
        
        let searchBar = app.navigationBars.searchFields["Search on Mercado Libre"]
        XCTAssertTrue(searchBar.exists, "Should navigate back to search screen")
    }
}
