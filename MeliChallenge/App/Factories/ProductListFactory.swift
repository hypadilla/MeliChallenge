//
//  ProductListFactory.swift
//  MeliChallenge
//
//  Created by Harold Padilla on 20/10/24.
//

import UIKit

protocol ProductListFactory {
    func makeModule(coordinator: ProductListControllerCoordinator, productList: [SearchItem]) -> UIViewController
    func makeCoordinatorProductDetail(navigation: UINavigationController, productId: String) -> ProductDetailCoordinator
}

struct ProductListFactoryImp: ProductListFactory {
    
    func makeModule(coordinator: ProductListControllerCoordinator, productList: [SearchItem]) -> UIViewController {
        let controller = ProductListController(
            collectionViewLayout: makeLayout(),
            coordinator: coordinator,
            productList: productList
        )
        controller.title = "product_list".localized
        return controller
    }
    
    func makeCoordinatorProductDetail(navigation: UINavigationController, productId: String) -> ProductDetailCoordinator {
        let factory = ProductDetailFactoryImp()
        return ProductDetailCoordinator(navigation: navigation, factory: factory, productItemId: productId)
    }
    
    private func makeLayout()-> UICollectionViewLayout{
        let layout = UICollectionViewFlowLayout()
        let layoutWidth = (AppConstants.widthScreen - 20) / 2
        let layoutHeight = (AppConstants.widthScreen) * 2 / 3
        layout.itemSize = CGSize(width: layoutWidth, height: layoutHeight)
        layout.minimumLineSpacing = .zero
        layout.minimumInteritemSpacing = .zero
        layout.sectionInset = UIEdgeInsets(top: .zero, left: 10, bottom: .zero, right: 10)
        return layout
    }
}
