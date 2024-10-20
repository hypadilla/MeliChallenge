//
//  SearchItem.swift
//  MeliChallenge
//
//  Created by Harold Padilla on 19/10/24.
//

import Foundation

struct SearchItem: Decodable {
    let id: String
    let title: String
    let price: Double
    let thumbnail: String
}
