//
//  LoadProductDetailUseCase.swift
//  MeliChallenge
//
//  Created by Harold Padilla on 20/10/24.
//

/// A protocol that defines the use case for loading product detail.
protocol LoadProductDetailUseCase {
    
    /// Executes the use case to load the product detail for the given product item ID.
    /// - Parameters:
    ///   - productItemId: The ID of the product item.
    /// - Returns: A `Result` object containing either the loaded `ProductDetail` or an `Error`.
    func execute(productItemId: String) async throws -> Result<ProductDetail, Error>
}

/// A concrete implementation of the `LoadProductDetailUseCase` protocol.
struct LoadProductDetailUseCaseImp: LoadProductDetailUseCase {
    let repository: ProductDetailRepository
    
    func execute(productItemId: String) async throws -> Result<ProductDetail, Error> {
        do {
            let result = try await repository.fetchProductDetailData(productItemId: productItemId)
            return .success(result)
        } catch {
            return .failure(error)
        }
    }
}
