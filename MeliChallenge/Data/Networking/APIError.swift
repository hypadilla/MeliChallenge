//
//  APIError.swift
//  MeliChallenge
//
//  Created by Harold Padilla on 19/10/24.
//

import Foundation

enum APIError: Error {
    case invalidURL
    case networkError(Error)
    case invalidResponse
    case responseError(statusCode: Int, data: Data?)
    case noData
    case dataParsingError(Error)
    case unknown
}
