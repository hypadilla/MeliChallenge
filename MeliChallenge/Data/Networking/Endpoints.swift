//
//  Endpoints.swift
//  MeliChallenge
//
//  Created by Harold Padilla on 19/10/24.
//

struct Endpoints {
    static func getProducts(query: String) -> String {
        let encodedQuery = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        return "sites/\(AppConstants.siteID)/search?q=\(encodedQuery)"
    }
}
