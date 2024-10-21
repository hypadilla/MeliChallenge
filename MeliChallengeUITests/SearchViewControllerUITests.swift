//
//  SearchViewControllerUITests.swift
//  MeliChallenge
//
//  Created by Harold Padilla on 19/10/24.
//

import XCTest

class SearchViewControllerUITests: XCTestCase {
    
    var app: XCUIApplication!
    
    override func setUp() {
        continueAfterFailure = false
        
        app = XCUIApplication()
        app.launch()
    }
    
    func testSearchBarExists() {
        let searchBar = app.navigationBars.searchFields["Search on Mercado Libre"]
        XCTAssertTrue(searchBar.exists, "Search bar should exist")
    }
    
    func testValidSearchShowsResults() {
        let searchBar = app.navigationBars.searchFields["Search on Mercado Libre"]
        searchBar.tap()
        searchBar.typeText("iPhone")
        app.keyboards.buttons["Search"].tap()
        
        let firstCell = app.collectionViews.cells.element(boundBy: 0)
        let exists = firstCell.waitForExistence(timeout: 5)
        XCTAssertTrue(exists, "First cell should exist after search")
    }
    
    func testCancelButtonHidesKeyboard() {
        let searchBar = app.navigationBars.searchFields["Search on Mercado Libre"]
        searchBar.tap()
        XCTAssertTrue(app.keyboards.element.exists, "Keyboard should be visible after tapping search bar")
        app.buttons["Cancel"].tap()
        XCTAssertFalse(app.keyboards.element.exists, "Keyboard should be hidden after tapping cancel")
    }
    
    func testNavigationToProductDetail() {
        let searchBar = app.navigationBars.searchFields["Search on Mercado Libre"]
        searchBar.tap()
        searchBar.typeText("iPhone")
        UIView.setAnimationsEnabled(false)
        
        app.keyboards.buttons["Search"].tap()

        let firstCell = app.collectionViews.cells.element(boundBy: 0)
        let exists = firstCell.waitForExistence(timeout: 5)
        XCTAssertTrue(exists, "First cell should exist")
        firstCell.tap()
        
        let productDetailTitle = app.staticTexts["new"]
        XCTAssertTrue(productDetailTitle.waitForExistence(timeout: 5), "Product detail should be displayed")
    }
    
    func testSwipeBackFromProductDetail() {
        XCUIDevice.shared.orientation = .portrait

        let searchBar = app.navigationBars.searchFields["Search on Mercado Libre"]
        searchBar.tap()
        searchBar.typeText("iPhone")
        app.keyboards.buttons["Search"].tap()
        
        let firstCell = app.collectionViews.cells.element(boundBy: 0)
        let exists = firstCell.waitForExistence(timeout: 5)
        XCTAssertTrue(exists, "First cell should exist")
        firstCell.tap()
        
        let productDetailTitle = app.staticTexts["new"]
        XCTAssertTrue(productDetailTitle.waitForExistence(timeout: 5), "Product detail should be displayed")
        
        app.navigationBars.buttons.element(boundBy: 0).tap()
        app.navigationBars.buttons.element(boundBy: 0).tap()

        XCTAssertTrue(searchBar.exists, "Should be back to search view controller")
    }
}
