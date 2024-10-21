//
//  SearchResponseDTO.swift
//  MeliChallenge
//
//  Created by Harold Padilla on 19/10/24.
//

import Foundation

/// The `SearchResponseDTO` struct represents a data transfer object (DTO) for the search response.
/// It contains the search results and paging information, conforming to `Decodable` to allow decoding from JSON.
struct SearchResponseDTO: Decodable {
    let results: [SearchDTO]
    let paging: PagingDTO
    
    /// Converts the `SearchResponseDTO` to a tuple containing an array of `SearchItem` and `Paging`.
    ///
    /// - Returns: A tuple with search items and paging information mapped to their domain models.
    func toDomain() -> (items: [SearchItem], paging: Paging) {
        let items = results.map { $0.toDomain() }
        let pagingDomain = paging.toDomain()
        return (items, pagingDomain)
    }
}

/// The `PagingDTO` struct represents a data transfer object (DTO) for pagination details.
/// It conforms to the `Decodable` protocol to support JSON decoding.
struct PagingDTO: Decodable {
    let total: Int
    let primary_results: Int
    let offset: Int
    let limit: Int
    
    /// Converts the `PagingDTO` to a domain model `Paging`.
    ///
    /// This method maps the DTO properties to the `Paging` domain model.
    ///
    /// - Returns: A `Paging` object.
    func toDomain() -> Paging {
        return Paging(total: total, primaryResults: primary_results, offset: offset, limit: limit)
    }
}
