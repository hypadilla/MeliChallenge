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
    func didSearchList(model: [SearchItem], paging: Paging, query: String) {
        goToProductList(model: model, paging: paging, query: query)
    }
    
    private func goToProductList(model: [SearchItem], paging: Paging, query: String) {
        let productListCoordinator = searchFactory.makeCoordinatorProductList(navigation: navigation, productList: model, query: query, paging: paging)
        productListCoordinator.start()
    }
}
