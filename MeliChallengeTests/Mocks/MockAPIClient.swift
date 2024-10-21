//
//  MockAPIClient.swift
//  MeliChallenge
//
//  Created by Harold Padilla on 19/10/24.
//

import Foundation
@testable import MeliChallenge

class MockAPIClient: APIClientProtocol {
    var result: Result<Data, Error>?
    var requestCount = 0
    var lastEndpoint: String?
    var lastMethod: HTTPMethod?
    var lastHeaders: [String: String]?
    var lastBody: Data?

    @discardableResult
    func request(
        endpoint: String,
        method: HTTPMethod = .GET,
        headers: [String : String]? = nil,
        body: Data? = nil,
        retries: Int = AppConstants.maxRetries,
        completion: @escaping (Result<Data, Error>) -> Void
    ) -> URLSessionDataTask {
        lastEndpoint = endpoint
        lastMethod = method
        lastHeaders = headers
        lastBody = body
        requestCount += 1

        if let result = result {
            completion(result)
        } else {
            completion(.failure(APIError.unknown))
        }

        return URLSessionDataTask()
    }
}
