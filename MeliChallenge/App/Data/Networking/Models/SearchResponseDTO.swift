//
//  SearchResponseDTO.swift
//  MeliChallenge
//
//  Created by Harold Padilla on 19/10/24.
//

import Foundation

struct SearchResponseDTO: Decodable {
    let results: [SearchDTO]
    let paging: PagingDTO
    
    func toDomain() -> (items: [SearchItem], paging: Paging) {
        let items = results.map { $0.toDomain() }
        let pagingDomain = paging.toDomain()
        return (items, pagingDomain)
    }
}

struct PagingDTO: Decodable {
    let total: Int
    let primary_results: Int
    let offset: Int
    let limit: Int
    
    func toDomain() -> Paging {
        return Paging(total: total, primaryResults: primary_results, offset: offset, limit: limit)
    }
}

