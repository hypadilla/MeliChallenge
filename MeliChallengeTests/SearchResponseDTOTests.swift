//
 //  SearchResponseDTOTests.swift
 //  MeliChallenge
 //
 //  Created by Harold Padilla on 20/10/24.
 //
 
import XCTest
@testable import MeliChallenge

class SearchResponseDTOTests: XCTestCase {
    func testToDomain_ConvertsResponseDTOToDomain() {
        // Arrange
        let dto = SearchResponseDTO(
            results: [
                SearchDTO(id: "1", title: "Item 1", price: 100.0, thumbnail: "http://example.com/image1.jpg"),
                SearchDTO(id: "2", title: "Item 2", price: 200.0, thumbnail: "http://example.com/image2.jpg")
            ],
            paging: PagingDTO(total: 2, primary_results: 2, offset: 0, limit: 50)
        )
        let expectedItems = [
            SearchItem(id: "1", title: "Item 1", price: 100.0, thumbnail: "http://example.com/image1.jpg"),
            SearchItem(id: "2", title: "Item 2", price: 200.0, thumbnail: "http://example.com/image2.jpg")
        ]
        let expectedPaging = Paging(total: 2, primaryResults: 2, offset: 0, limit: 50)
        
        // Act
        let (items, paging) = dto.toDomain()
        
        // Assert
        XCTAssertEqual(items, expectedItems, "Items should match expected items")
        XCTAssertEqual(paging, expectedPaging, "Paging should match expected paging")
    }
}
