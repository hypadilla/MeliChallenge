//
//  StateController.swift
//  MeliChallenge
//
//  Created by Harold Padilla on 19/10/24.
//

enum StateController: Equatable {
    case success
    case loading
    case fail(error: String)
}

