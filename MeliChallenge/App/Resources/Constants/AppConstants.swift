//
//  AppConstants.swift
//  MeliChallenge
//
//  Created by Harold Padilla on 19/10/24.
//

import Foundation
import UIKit

struct AppConstants {
    static let baseURL = "https://api.mercadolibre.com/"
    static let siteID = "MCO"
    static let timeoutInterval: TimeInterval = 60
    static let maxRetries = 3
    static let defaultHeaders: [String: String] = [
        "Content-Type": "application/json"
    ]
    
    static let tagIdentifierSpinner = 100
    static let opacityContainerSpinner: CGFloat = 0.3
    static let cornerRadiusSearchBar: CGFloat = 18.0
    static let itemsPerPage = 50
    static let widthScreen = UIScreen.main.bounds.width
}
