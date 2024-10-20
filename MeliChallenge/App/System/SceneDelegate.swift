//
//  SceneDelegate.swift
//  MeliChallenge
//
//  Created by Harold Padilla on 18/10/24.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    var appCoordinator: Coordinator!
    var appFactory: AppFactory!
    
    func scene(_ scene: UIScene,
                   willConnectTo session: UISceneSession,
                   options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        let navigation = UINavigationController()
        window = UIWindow(windowScene: windowScene)
        appFactory = AppFactoryImp()
        appCoordinator = AppCoordinator(navigation: navigation, appFactory: appFactory, window: window)
        appCoordinator.start()
    }

    func sceneDidDisconnect(_ scene: UIScene) {

    }

    func sceneDidBecomeActive(_ scene: UIScene) {

    }

    func sceneWillResignActive(_ scene: UIScene) {

    }

    func sceneWillEnterForeground(_ scene: UIScene) {

    }

    func sceneDidEnterBackground(_ scene: UIScene) {

    }
}
