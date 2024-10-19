//
//  AppConstants.swift
//  MeliChallenge
//
//  Created by Harold Padilla on 19/10/24.
//

import Foundation

struct AppConstants {
    static let baseURL = "https://api.mercadolibre.com/"
    static let siteID = "MCO"
    static let timeoutInterval: TimeInterval = 60
    static let maxRetries = 3
    static let defaultHeaders: [String: String] = [
        "Content-Type": "application/json"
    ]
}
