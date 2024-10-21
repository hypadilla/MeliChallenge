//
//  LoadSearchUseCase.swift
//  MeliChallenge
//
//  Created by Harold Padilla on 19/10/24.
//

import Foundation

protocol LoadSearchUseCase {
    func execute(query: String, offset: Int, limit: Int) async throws -> (items: [SearchItem], paging: Paging)
}

struct LoadSearchUseCaseImp: LoadSearchUseCase {
    let repository: SearchRepository
    
    func execute(query: String, offset: Int, limit: Int) async throws -> (items: [SearchItem], paging: Paging) {
        return try await repository.fetchSearchData(query: query, offset: offset, limit: limit)
    }
}
