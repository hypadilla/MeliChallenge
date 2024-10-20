//
//  ProductDetailCoordinator.swift
//  MeliChallenge
//
//  Created by Harold Padilla on 20/10/24.
//

import UIKit

/// The coordinator responsible for handling the product detail screen.
final class ProductDetailCoordinator: Coordinator, ProductDetailControllerCoordinator {
    var navigation: UINavigationController
    private var factory: ProductDetailFactory
    private var productItemId: String
    
    /// Initializes the product detail coordinator.
    /// - Parameters:
    ///   - navigation: The navigation controller to be used for navigation.
    ///   - factory: The factory responsible for creating the product detail module.
    ///   - productItemId: The ID of the product to be displayed.
    init(navigation: UINavigationController, factory: ProductDetailFactory, productItemId: String) {
        self.navigation = navigation
        self.factory = factory
        self.productItemId = productItemId
    }
    
    /// Starts the product detail coordinator.
    func start() {
        let controller = factory.makeModule(coordinator: self, productItemId: productItemId)
        navigation.navigationBar.prefersLargeTitles = true
        navigation.pushViewController(controller, animated: true)
    }
}
