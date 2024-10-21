//
//  Endpoints.swift
//  MeliChallenge
//
//  Created by Harold Padilla on 19/10/24.
//

import Foundation

struct Endpoints {
    static func getProducts(query: String, offset: Int, limit: Int) -> String {
        let encodedQuery = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        return "sites/\(AppConstants.siteID)/search?q=\(encodedQuery)&offset=\(offset)&limit=\(limit)"
    }
    
    static func getProduct(productItemId: String) -> String {
        return "items/\(productItemId)"
    }
}
