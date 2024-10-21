//
//  SearchFactory.swift
//  MeliChallenge
//
//  Created by Harold Padilla on 19/10/24.
//

import UIKit
import Combine

protocol SearchFactory {
    func makeModule(coordinator: SearchViewControllerCoordinator) -> UIViewController
    func makeCoordinatorProductList(navigation: UINavigationController, productList: [SearchItem], query: String, paging: Paging) -> Coordinator
}

struct SearchFactoryImp: SearchFactory {
    private let loadSearchUseCase: LoadSearchUseCase
    
    init() {
        let apiClient = APIClient.shared
        let networkService = NetworkService(apiClient: apiClient)
        let searchRepository = SearchRepositoryImp(networkService: networkService)
        self.loadSearchUseCase = LoadSearchUseCaseImp(repository: searchRepository)
    }
    
    func makeModule(coordinator: SearchViewControllerCoordinator) -> UIViewController {
        let state = PassthroughSubject<StateController, Never>()
        let searchViewModel = SearchViewModelImp(state: state, loadSearchUseCase: loadSearchUseCase)
        let searchViewController = SearchViewController(viewModel: searchViewModel, coordinator: coordinator)
        searchViewController.title = "appName".localized
        return searchViewController
    }
    
    func makeCoordinatorProductList(navigation: UINavigationController, productList: [SearchItem], query: String, paging: Paging) -> Coordinator {
        let productListFactory = ProductListFactoryImp()
        return ProductListCoordinator(navigation: navigation, factory: productListFactory, productList: productList, query: query, paging: paging, loadSearchUseCase: loadSearchUseCase)
    }
}
