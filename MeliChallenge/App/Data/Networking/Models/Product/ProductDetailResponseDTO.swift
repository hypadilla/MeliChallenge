//
//  ProductDetailResponseDTO.swift
//  MeliChallenge
//
//  Created by Harold Padilla on 20/10/24.
//

struct ProductDetailResponseDTO: Decodable {
    let id: String
    let title: String
    let price: Double
    let condition: String
    let pictures: [PictureDTO]
    
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
