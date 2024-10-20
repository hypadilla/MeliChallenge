//
//  ProductDetailFactory.swift
//  MeliChallenge
//
//  Created by Harold Padilla on 20/10/24.
//

import UIKit
import Combine

/// A factory protocol for creating the product detail module.
protocol ProductDetailFactory {
    
    /// Creates and returns the product detail module.
    /// - Parameters:
    ///   - coordinator: The coordinator for the product detail module.
    ///   - productItemId: The ID of the product item.
    /// - Returns: The view controller representing the product detail module.
    func makeModule(coordinator: ProductDetailControllerCoordinator, productItemId: String) -> UIViewController
}

/// The implementation of the `ProductDetailFactory` protocol.
struct ProductDetailFactoryImp: ProductDetailFactory {
    
    func makeModule(coordinator: ProductDetailControllerCoordinator, productItemId: String) -> UIViewController {
        let apiClient = APIClient.shared
        let networkService = NetworkService(apiClient: apiClient)
        let productDetailRepository = ProductDetailRepositoryImp(networkService: networkService)
        let state = PassthroughSubject<StateController, Never>()
        
        let loadProductDetailUseCase = LoadProductDetailUseCaseImp(repository: productDetailRepository)
        
        let productDetailViewModel = ProductDetailViewModelImp(state: state, loadProductDetailUseCase: loadProductDetailUseCase)
        
        let productDetailController = ProductDetailController(viewModel: productDetailViewModel, coordinator: coordinator, productItemId: productItemId)
        
        return productDetailController
    }
}
