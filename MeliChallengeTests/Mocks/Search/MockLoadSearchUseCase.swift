//
//  MockLoadSearchUseCase.swift
//  MeliChallenge
//
//  Created by Harold Padilla on 20/10/24.
//

@testable import MeliChallenge

class MockLoadSearchUseCase: LoadSearchUseCase {
    var result: Result<(items: [SearchItem], paging: Paging), Error>!

    func execute(query: String, offset: Int, limit: Int) async throws -> (items: [SearchItem], paging: Paging) {
        switch result {
        case .success(let data):
            return data
        case .failure(let error):
            throw error
        case .none:
            let emptyPaging = Paging(total: 0, primaryResults: 0, offset: offset, limit: limit)
            return (items: [], paging: emptyPaging)
        }
    }
}
