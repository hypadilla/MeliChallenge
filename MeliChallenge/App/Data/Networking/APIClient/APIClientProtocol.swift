//
//  APIClientProtocol.swift
//  MeliChallenge
//
//  Created by Harold Padilla on 19/10/24.
//

import Foundation

protocol APIClientProtocol {
    @discardableResult
    func request(
        endpoint: String,
        method: HTTPMethod,
        headers: [String: String]?,
        body: Data?,
        retries: Int,
        completion: @escaping (Result<Data, Error>) -> Void
    ) -> URLSessionDataTask
}
