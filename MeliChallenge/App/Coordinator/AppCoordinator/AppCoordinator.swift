//
//  AppCoordinator.swift
//  MeliChallenge
//
//  Created by Harold Padilla on 19/10/24.
//

import UIKit

final class AppCoordinator: Coordinator {
    var navigation: UINavigationController
    private let appFactory: AppFactory
    private var coordinator: Coordinator?
    
    init(navigation: UINavigationController,
         appFactory: AppFactory,
         window: UIWindow?) {
        self.navigation = navigation
        self.appFactory = appFactory
        configWindow(window: window)
    }
    
    func start() {
        coordinator = appFactory.makeSearchCoordinator(navigation: navigation)
        coordinator?.start()
    }
    
    private func configWindow(window: UIWindow?){
        window?.rootViewController = navigation
        window?.makeKeyAndVisible()
    }
}
