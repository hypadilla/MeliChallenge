//
//  SearchCoordinator.swift
//  MeliChallenge
//
//  Created by Harold Padilla on 19/10/24.
//

import UIKit

final class SearchCoordinator: Coordinator {
    var navigation: UINavigationController
    private let searchFactory: SearchFactory
    
    init(navigation: UINavigationController, searchFactory: SearchFactory) {
        self.navigation = navigation
        self.searchFactory = searchFactory
    }
    
    func start() {
        let viewController = searchFactory.makeModule(coordinator: self)
        navigation.pushViewController(viewController, animated: true)
    }
}

extension SearchCoordinator: SearchViewControllerCoordinator {
    func didSearchList(model: [SearchItem]) {
        goToProductList(model: model)
    }
    
    private func goToProductList(model: [SearchItem]) {
        let productListCoordinator = searchFactory.makeCoordinatorProductList(navigation: navigation, productList: model)
        productListCoordinator.start()
    }
}
