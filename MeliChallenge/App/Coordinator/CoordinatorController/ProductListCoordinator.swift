//
//  ProductListCoordinator.swift
//  MeliChallenge
//
//  Created by Harold Padilla on 20/10/24.
//

import UIKit

/// The `ProductListCoordinator` is responsible for managing the flow related to displaying a list of products.
/// It handles navigation from the product list to the product detail and manages product pagination.
final class ProductListCoordinator: Coordinator {
    var navigation: UINavigationController
    private var factory: ProductListFactory
    private var productList: [SearchItem]
    private var query: String
    private var paging: Paging
    private let loadSearchUseCase: LoadSearchUseCase
    private var isLoading = false
    
    /// Initializes the `ProductListCoordinator` with required dependencies.
    ///
    /// - Parameters:
    ///   - navigation: The navigation controller responsible for handling the navigation stack.
    ///   - factory: The factory responsible for creating product list-related components.
    ///   - productList: The list of products that will be initially displayed.
    ///   - query: The search query string.
    ///   - paging: The paging object that manages pagination information for the product list.
    ///   - loadSearchUseCase: The use case responsible for loading more products when needed.
    init(navigation: UINavigationController,
         factory: ProductListFactory,
         productList: [SearchItem],
         query: String,
         paging: Paging,
         loadSearchUseCase: LoadSearchUseCase) {
        self.navigation = navigation
        self.factory = factory
        self.productList = productList
        self.query = query
        self.paging = paging
        self.loadSearchUseCase = loadSearchUseCase
    }
    
    /// Starts the product list flow by creating the product list module and pushing it onto the navigation stack.
    func start() {
        let controller = factory.makeModule(coordinator: self, productList: productList)
        navigation.navigationBar.prefersLargeTitles = true
        navigation.pushViewController(controller, animated: true)
    }
}

extension ProductListCoordinator: ProductListControllerCoordinator {
    
    /// Handles the selection of a product in the product list.
    /// This method navigates to the product detail screen.
    ///
    /// - Parameter productId: The ID of the selected product.
    func didSelectProductItem(productId: String) {
        goToProductDetail(productId: productId)
    }
    
    /// Loads more products when the user reaches the end of the current product list.
    /// It checks if more products are available and if the current loading process is not already in progress.
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
    
    /// Navigates to the product detail screen for the selected product.
    ///
    /// - Parameter productId: The ID of the selected product.
    private func goToProductDetail(productId: String) {
        let productDetailCoordinator = factory.makeCoordinatorProductDetail(navigation: navigation, productId: productId)
        productDetailCoordinator.start()
    }
}
