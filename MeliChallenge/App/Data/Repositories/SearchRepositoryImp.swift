//
//  SearchRepositoryImp.swift
//  MeliChallenge
//
//  Created by Harold Padilla on 19/10/24.
//

import Foundation

class SearchRepositoryImp: SearchRepository {
    private let networkService: NetworkServiceProtocol

    init(networkService: NetworkServiceProtocol) {
        self.networkService = networkService
    }

    func fetchSearchData(query: String, offset: Int, limit: Int) async throws -> (items: [SearchItem], paging: Paging) {
        let endpoint = Endpoints.getProducts(query: query, offset: offset, limit: limit)
        return try await withCheckedThrowingContinuation { continuation in
            networkService.fetchData(from: endpoint, method: .GET, headers: nil, body: nil) { (result: Result<SearchResponseDTO, Error>) in
                switch result {
                case .success(let response):
                    let domainData = response.toDomain()
                    continuation.resume(returning: domainData)
                case .failure(let error):
                    continuation.resume(throwing: error)
                }
            }
        }
    }
}
