//
//  ProductDetailResponseDTO.swift
//  MeliChallenge
//
//  Created by Harold Padilla on 20/10/24.
//

/// The `ProductDetailResponseDTO` struct represents a data transfer object (DTO) for a product detail response from the API.
/// It conforms to the `Decodable` protocol to allow decoding from JSON.
struct ProductDetailResponseDTO: Decodable {
    let id: String
    let title: String
    let price: Double
    let condition: String
    let pictures: [PictureDTO]
    
    /// Converts the `ProductDetailResponseDTO` to a domain model `ProductDetail`.
    ///
    /// This function maps the properties from the DTO to the corresponding `ProductDetail` domain model.
    ///
    /// - Returns: A `ProductDetail` domain model object.
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
