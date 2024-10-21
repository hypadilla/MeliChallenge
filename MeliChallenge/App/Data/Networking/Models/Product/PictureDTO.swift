//
//  PictureDTO.swift
//  MeliChallenge
//
//  Created by Harold Padilla on 20/10/24.
//

/// The `PictureDTO` struct represents a data transfer object (DTO) for a picture associated with a product.
/// It conforms to the `Decodable` protocol to support decoding from JSON data.
struct PictureDTO: Decodable {
    let secure_url: String
    
    /// Converts the `PictureDTO` to a domain model `Picture`.
    ///
    /// This function maps the `secure_url` from the DTO to the domain model `Picture`.
    ///
    /// - Returns: A `Picture` object with the corresponding URL.
    func toDomain() -> Picture {
        return Picture(secure_url: self.secure_url)
    }
}
