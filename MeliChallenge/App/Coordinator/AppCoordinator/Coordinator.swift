//
//  Coordinator.swift
//  MeliChallenge
//
//  Created by Harold Padilla on 19/10/24.
//

import UIKit

/// The `Coordinator` protocol defines the basic structure that all coordinators must follow.
/// Coordinators are responsible for managing the navigation flow in the app and
/// ensuring that the transitions between view controllers are handled in a modular and organized way.
protocol Coordinator {
    var navigation: UINavigationController { get }
    func start()
}
