//
//  AppCoordinator.swift
//  MeliChallenge
//
//  Created by Harold Padilla on 19/10/24.
//

import UIKit

/// The `AppCoordinator` class is responsible for coordinating the navigation flow of the application.
/// It manages the main navigation controller and initializes the necessary module coordinators.
final class AppCoordinator: Coordinator {

    /// The navigation controller that manages the navigation stack of the app.
    var navigation: UINavigationController
    
    /// The factory responsible for creating other coordinators and dependencies needed by the app.
    private let appFactory: AppFactory
    
    /// A reference to the current active coordinator, which could be managing a specific flow.
    private var coordinator: Coordinator?
    
    /// Initializes the `AppCoordinator` with the necessary dependencies.
    ///
    /// - Parameters:
    ///   - navigation: The navigation controller responsible for managing the app's navigation stack.
    ///   - appFactory: The factory that provides coordinators and other necessary components.
    ///   - window: The app's main window where the root view controller will be set.
    init(navigation: UINavigationController,
         appFactory: AppFactory,
         window: UIWindow?) {
        self.navigation = navigation
        self.appFactory = appFactory
        configWindow(window: window)
    }
    
    /// Starts the app's coordination by creating the `SearchCoordinator`
    /// and delegating control to it for the search flow.
    func start() {
        coordinator = appFactory.makeSearchCoordinator(navigation: navigation)
        coordinator?.start()
    }
    
    /// Configures the app's main window by setting the root view controller to the navigation controller
    /// and making the window key and visible.
    ///
    /// - Parameter window: The app's main window.
    private func configWindow(window: UIWindow?) {
        window?.rootViewController = navigation
        window?.makeKeyAndVisible()
    }
}
