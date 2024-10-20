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
        let searchBar = app.navigationBars.searchFields["Buscar en Mercado Libre"]
        XCTAssertTrue(searchBar.exists)
    }

    func testValidSearchShowsResults() {
        let searchBar = app.navigationBars.searchFields["Buscar en Mercado Libre"]
        searchBar.tap()
        searchBar.typeText("iPhone")
        app.keyboards.buttons["buscar"].tap()
    }
}
