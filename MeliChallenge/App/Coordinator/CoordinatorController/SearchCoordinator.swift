//
//  SearchCoordinator.swift
//  MeliChallenge
//
//  Created by Harold Padilla on 19/10/24.
//

import UIKit

/// The `SearchCoordinator` is responsible for managing the search flow in the app.
/// It handles the transition from the search view to the product list view when a search is performed.
final class SearchCoordinator: Coordinator {
    var navigation: UINavigationController
    private let searchFactory: SearchFactory
    
    /// Initializes the `SearchCoordinator` with the navigation controller and search factory.
    ///
    /// - Parameters:
    ///   - navigation: The navigation controller responsible for handling the navigation stack.
    ///   - searchFactory: The factory that provides modules and coordinators related to the search flow.
    init(navigation: UINavigationController, searchFactory: SearchFactory) {
        self.navigation = navigation
        self.searchFactory = searchFactory
    }
    
    /// Starts the search flow by creating the search module and pushing it onto the navigation stack.
    func start() {
        let viewController = searchFactory.makeModule(coordinator: self)
        navigation.pushViewController(viewController, animated: true)
    }
}

extension SearchCoordinator: SearchViewControllerCoordinator {
    
    /// Handles the event when a search is performed and a list of products is returned.
    ///
    /// - Parameters:
    ///   - model: The list of search items (products) returned from the search.
    ///   - paging: The paging information for the product list.
    ///   - query: The search query string used to fetch the products.
    func didSearchList(model: [SearchItem], paging: Paging, query: String) {
        goToProductList(model: model, paging: paging, query: query)
    }
    
    /// Navigates to the product list view when a search is performed.
    ///
    /// - Parameters:
    ///   - model: The list of search items (products) returned from the search.
    ///   - paging: The paging information for the product list.
    ///   - query: The search query string used to fetch the products.
    private func goToProductList(model: [SearchItem], paging: Paging, query: String) {
        let productListCoordinator = searchFactory.makeCoordinatorProductList(navigation: navigation, productList: model, query: query, paging: paging)
        productListCoordinator.start()
    }
}
