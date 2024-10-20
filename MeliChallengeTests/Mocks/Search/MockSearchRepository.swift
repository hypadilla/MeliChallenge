//
//  MockSearchRepository.swift
//  MeliChallenge
//
//  Created by Harold Padilla on 20/10/24.
//

@testable import MeliChallenge

class MockSearchRepository: SearchRepository {
    var result: Result<[SearchItem], Error>!

    func fetchSearchData(query: String, offset: Int, limit: Int) async throws -> (items: [SearchItem], paging: Paging) {
        switch result {
        case .success(let items):
            let paging = Paging(total: items.count, primaryResults: items.count, offset: offset, limit: limit)
            return (items, paging)
        case .failure(let error):
            throw error
        case .none:
            return ([], Paging(total: 0, primaryResults: 0, offset: offset, limit: limit))
        }
    }
}
