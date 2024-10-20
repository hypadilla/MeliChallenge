//
//  SearchRepository.swift
//  MeliChallenge
//
//  Created by Harold Padilla on 19/10/24.
//

import Foundation

protocol SearchRepository {
    func fetchSearchData(query: String, offset: Int, limit: Int) async throws -> (items: [SearchItem], paging: Paging)
}
