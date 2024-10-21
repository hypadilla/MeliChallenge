//
//  ProductDetailViewModel.swift
//  MeliChallenge
//
//  Created by Harold Padilla on 20/10/24.
//

import Combine

/// The protocol for the product detail view model.
protocol ProductDetailViewModel {
    var state: PassthroughSubject<StateController, Never> { get }
    var productDetail: ProductDetail { get }
    func loadProduct(productItemId: String)
}

/// The implementation of the product detail view model.
final class ProductDetailViewModelImp: ProductDetailViewModel {
    var state: PassthroughSubject<StateController, Never>
    
    private let loadProductDetailUseCase: LoadProductDetailUseCase
    internal var productDetail: ProductDetail = ProductDetail(id: String(), title: String(), price: .zero,  condition: String(), pictures: [])
    
    init(state: PassthroughSubject<StateController, Never>, loadProductDetailUseCase: LoadProductDetailUseCase) {
        self.loadProductDetailUseCase = loadProductDetailUseCase
        self.state = state
    }
    
    var product : ProductDetail {
        return productDetail
    }
    
    /// Loads the product with the specified item ID.
    /// - Parameter productItemId: The ID of the product item to load.
    func loadProduct(productItemId: String) {
        state.send(.loading)
        Task {
            do {
                let result = try await loadProductDetailUseCase.execute(productItemId: productItemId)
                switch result {
                case .success(let item):
                    self.productDetail = item
                    state.send(.success)
                    Logger.log("product_loaded_successfully".localized, level: .info)
                case .failure(let error):
                    state.send(.fail(error: error.localizedDescription))
                    Logger.log("\("error_loading_product".localized) \(error.localizedDescription)", level: .error)
                }
            } catch {
                state.send(.fail(error: error.localizedDescription))
                Logger.log("\("error_loading_product".localized) \(error.localizedDescription)", level: .error)
            }
        }
    }
}
