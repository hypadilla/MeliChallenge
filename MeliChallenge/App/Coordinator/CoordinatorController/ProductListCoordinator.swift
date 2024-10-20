//
//  ProductListCoordinator.swift
//  MeliChallenge
//
//  Created by Harold Padilla on 20/10/24.
//

import UIKit

final class ProductListCoordinator: Coordinator {
    var navigation: UINavigationController
    private var factory: ProductListFactory
    private var productList: [SearchItem]
    
    init(navigation: UINavigationController, factory: ProductListFactory, productList: [SearchItem]) {
        self.navigation = navigation
        self.factory = factory
        self.productList = productList
    }
    
    func start() {
        let controller = factory.makeModule(coordinator: self, productList: productList)
        navigation.navigationBar.prefersLargeTitles = true
        navigation.pushViewController(controller, animated: true)
    }
}

extension ProductListCoordinator: ProductListControllerCoordinator {
    /// Handles the selection of a product item in the product list.
    /// - Parameter productId: The ID of the selected product.
    func didSelectProductItem(productId: String) {
        goToProductDetail(productId: productId)
    }
    
    private func goToProductDetail(productId: String) {
        let productDetailCoordinator = factory.makeCoordinatorProductDetail(navigation: navigation, productId: productId)
        productDetailCoordinator.start()
    }
}
