//
//  ProductDetailRepositoryImp.swift
//  MeliChallenge
//
//  Created by Harold Padilla on 20/10/24.
//

import Foundation


class ProductDetailRepositoryImp: ProductDetailRepository {
    private let networkService: NetworkServiceProtocol

    init(networkService: NetworkServiceProtocol) {
        self.networkService = networkService
    }
    
    func fetchProductDetailData(productItemId: String) async throws -> ProductDetail {
        let endpoint = Endpoints.getProduct(productItemId: productItemId)
        
        return try await withCheckedThrowingContinuation { continuation in
            networkService.fetchData(from: endpoint, method: .GET, headers: nil, body: nil) { (result: Result<ProductDetailResponseDTO, Error>) in
                switch result {
                case .success(let response):
                    let domainData = response.toDomain()
                    continuation.resume(returning: domainData)
                case .failure(let error):
                    continuation.resume(throwing: error)
                }
            }
        }
    }
}
