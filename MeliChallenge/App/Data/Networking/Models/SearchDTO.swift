//
//  SearchDTO.swift
//  MeliChallenge
//
//  Created by Harold Padilla on 19/10/24.
//

import Foundation

struct SearchDTO: Decodable {
    let id: String
    let title: String
    let price: Double
    let thumbnail: String
    
    func toDomain() -> SearchItem {
        return SearchItem(id: id, title: title, price: price, thumbnail: thumbnail)
    }
}
