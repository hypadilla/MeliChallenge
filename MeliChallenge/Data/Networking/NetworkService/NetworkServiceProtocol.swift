//
//  NetworkServiceProtocol.swift
//  MeliChallenge
//
//  Created by Harold Padilla on 19/10/24.
//

import Foundation


protocol NetworkServiceProtocol {
    func fetchData<T: Decodable>(
        from endpoint: String,
        method: HTTPMethod,
        headers: [String: String]?,
        body: Data?,
        completion: @escaping (Result<T, Error>) -> Void
    )
}
