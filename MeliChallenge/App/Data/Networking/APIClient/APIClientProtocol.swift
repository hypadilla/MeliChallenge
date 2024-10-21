//
//  APIClientProtocol.swift
//  MeliChallenge
//
//  Created by Harold Padilla on 19/10/24.
//

import Foundation

/// The `APIClientProtocol` defines the contract for any API client that makes network requests.
/// It enforces the implementation of a request method for performing HTTP requests.
protocol APIClientProtocol {
    
    /// Makes a network request to the specified endpoint.
    ///
    /// - Parameters:
    ///   - endpoint: The API endpoint to be appended to the base URL.
    ///   - method: The HTTP method to be used for the request (e.g., `.GET`, `.POST`).
    ///   - headers: An optional dictionary of HTTP headers to include in the request.
    ///   - body: An optional `Data` object representing the request body.
    ///   - retries: The number of times the request should be retried in case of failure.
    ///   - completion: A closure that is called when the request completes, with a `Result` containing either the response `Data` or an `Error`.
    ///
    /// - Returns: A `URLSessionDataTask` representing the ongoing request.
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
