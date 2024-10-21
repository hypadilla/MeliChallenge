//
//  ProductDetailDTO.swift
//  MeliChallenge
//
//  Created by Harold Padilla on 20/10/24.
//

/// The `ProductDetailDTO` struct represents a data transfer object (DTO) for product details.
/// It conforms to the `Decodable` protocol to support decoding from JSON data.
struct ProductDetailDTO: Decodable {
    let id: String
    let title: String
    let price: Double
    let condition: String
    let pictures: [PictureDTO]
    
    /// Converts the `ProductDetailDTO` to a domain model `ProductDetail`.
    ///
    /// This function maps the DTO properties to the `ProductDetail` domain model,
    /// including mapping the pictures array to domain objects.
    ///
    /// - Returns: A `ProductDetail` object.
    func toDomain() -> ProductDetail {
        return ProductDetail(
            id: id,
            title: title,
            price: price,
            condition: condition,
            pictures: pictures.map { $0.toDomain() }
        )
    }
}
