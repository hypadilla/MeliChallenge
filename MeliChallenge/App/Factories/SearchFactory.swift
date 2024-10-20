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
    func makeCoordinatorProductList(navigation: UINavigationController, productList: [SearchItem]) -> Coordinator
}

struct SearchFactoryImp: SearchFactory {
    func makeModule(coordinator: SearchViewControllerCoordinator) -> UIViewController {
        let apiClient = APIClient.shared
        let networkService = NetworkService(apiClient: apiClient)
        let searchRepository = SearchRepositoryImp(networkService: networkService)
        let state = PassthroughSubject<StateController, Never>()
        let loadSearchUseCase = LoadSearchUseCaseImp(repository: searchRepository)
        
        let searchViewModel = SearchViewModelImp(state: state, loadSearchUseCase: loadSearchUseCase)
        
        let searchViewController = SearchViewController(viewModel: searchViewModel, coordinator: coordinator)
        searchViewController.title = "appName".localized
        return searchViewController
    }
    
    func makeCoordinatorProductList(navigation: UINavigationController, productList: [SearchItem]) -> Coordinator {
        let productListFactory = ProductListFactoryImp()
        return ProductListCoordinator(navigation: navigation, factory: productListFactory, productList: productList)
    }
}
