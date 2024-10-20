//
//  AppFactory.swift
//  MeliChallenge
//
//  Created by Harold Padilla on 19/10/24.
//

import UIKit

protocol AppFactory {
    func makeSearchCoordinator(navigation: UINavigationController) -> Coordinator
}

struct AppFactoryImp: AppFactory {
    func makeSearchCoordinator(navigation: UINavigationController) -> Coordinator {
        let searchFactory = SearchFactoryImp()
        return SearchCoordinator(navigation: navigation, searchFactory: searchFactory)
    }
}
