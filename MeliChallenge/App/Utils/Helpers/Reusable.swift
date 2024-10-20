//
//  Reusable.swift
//  MeliChallenge
//
//  Created by Harold Padilla on 20/10/24.
//

/// A protocol that defines a reusable component.
protocol Reusable {
    
}

extension Reusable {
    /// A computed property that returns the reuse identifier for the reusable component.
    static var reuseIdentifier: String { String(describing: self) }
}
