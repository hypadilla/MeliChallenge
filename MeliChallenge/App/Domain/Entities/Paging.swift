//
//  Paging.swift
//  MeliChallenge
//
//  Created by Harold Padilla on 20/10/24.
//

import Foundation

struct Paging: Equatable {
    let total: Int
    let primaryResults: Int
    let offset: Int
    let limit: Int
}
