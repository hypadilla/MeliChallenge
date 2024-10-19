//
//  MockNetworkService.swift
//  MeliChallenge
//
//  Created by Harold Padilla on 19/10/24.
//

import Foundation
@testable import MeliChallenge

class MockNetworkService: NetworkServiceProtocol {
    var result: Result<Decodable, Error>?
    var fetchDataCalled = false
    var lastEndpoint: String?
    var lastMethod: HTTPMethod?
    var lastHeaders: [String: String]?
    var lastBody: Data?

    func fetchData<T>(
        from endpoint: String,
        method: HTTPMethod = .GET,
        headers: [String : String]? = nil,
        body: Data? = nil,
        completion: @escaping (Result<T, Error>) -> Void
    ) where T : Decodable {
        fetchDataCalled = true
        lastEndpoint = endpoint
        lastMethod = method
        lastHeaders = headers
        lastBody = body

        if let result = result as? Result<T, Error> {
            completion(result)
        } else {
            completion(.failure(APIError.unknown))
        }
    }
}
