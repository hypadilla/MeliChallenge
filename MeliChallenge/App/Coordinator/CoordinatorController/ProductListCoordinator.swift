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
    private var query: String
    private var paging: Paging
    private let loadSearchUseCase: LoadSearchUseCase
    private var isLoading = false
    
    init(navigation: UINavigationController, factory: ProductListFactory, productList: [SearchItem], query: String, paging: Paging, loadSearchUseCase: LoadSearchUseCase) {
        self.navigation = navigation
        self.factory = factory
        self.productList = productList
        self.query = query
        self.paging = paging
        self.loadSearchUseCase = loadSearchUseCase
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
    
    func loadMoreProducts() {
        guard !isLoading else { return }
        guard paging.offset + paging.limit < paging.total else { return }
        
        isLoading = true
        let newOffset = paging.offset + paging.limit
        
        Task {
            do {
                let (items, newPaging) = try await loadSearchUseCase.execute(query: query, offset: newOffset, limit: paging.limit)
                DispatchQueue.main.async {
                    self.productList.append(contentsOf: items)
                    self.paging = newPaging
                    if let controller = self.navigation.topViewController as? ProductListController {
                        controller.appendProducts(items)
                    }
                    self.isLoading = false
                }
            } catch {
                DispatchQueue.main.async {
                    self.isLoading = false
                    Logger.log("Error al cargar más productos: \(error.localizedDescription)", level: .error)
                }
            }
        }
    }
    
    private func goToProductDetail(productId: String) {
        let productDetailCoordinator = factory.makeCoordinatorProductDetail(navigation: navigation, productId: productId)
        productDetailCoordinator.start()
    }
}
