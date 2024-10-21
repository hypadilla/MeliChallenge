//
//  SearchDTO.swift
//  MeliChallenge
//
//  Created by Harold Padilla on 19/10/24.
//

import Foundation

/// The `SearchDTO` struct represents a data transfer object (DTO) for search results.
/// It conforms to the `Decodable` protocol to allow decoding from JSON data.
struct SearchDTO: Decodable {
    let id: String
    let title: String
    let price: Double
    let thumbnail: String
    
    /// Converts the `SearchDTO` to a domain model `SearchItem`.
    ///
    /// This method maps the properties from the DTO to the corresponding `SearchItem` domain model.
    ///
    /// - Returns: A `SearchItem` object.
    func toDomain() -> SearchItem {
        return SearchItem(id: id, title: title, price: price, thumbnail: thumbnail)
    }
}
