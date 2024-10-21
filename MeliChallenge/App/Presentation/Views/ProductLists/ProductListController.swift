//
//  ProductListController.swift
//  MeliChallenge
//
//  Created by Harold Padilla on 20/10/24.
//

import UIKit

protocol ProductListControllerCoordinator {
    func didSelectProductItem(productId: String)
    func loadMoreProducts()
}

final class ProductListController: UICollectionViewController {
    
    private let coordinator: ProductListControllerCoordinator
    private var productList: [SearchItem] = []
    
    private var isLoadingMore = false
    
    init(collectionViewLayout: UICollectionViewLayout, coordinator: ProductListControllerCoordinator, productList: [SearchItem]) {
        self.coordinator = coordinator
        self.productList = productList
        super.init(collectionViewLayout: collectionViewLayout)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configUI()
        configCollectionView()
    }
    
    private func configUI() {
        view.backgroundColor = .systemBackground
    }
    
    private func configCollectionView() {
        collectionView.register(ProductListItemViewCell.self, forCellWithReuseIdentifier: ProductListItemViewCell.reuseIdentifier)
    }
}

extension ProductListController {
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return productList.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: ProductListItemViewCell.reuseIdentifier,
            for: indexPath
        ) as? ProductListItemViewCell
        else {
            Logger.log("\("failedToDequeueCell".localized) \(indexPath)", level: .error)
            return UICollectionViewCell()
        }
        
        let product = productList[indexPath.item]
        cell.configure(with: product)
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let product = productList[indexPath.item]
        coordinator.didSelectProductItem(productId: product.id)
    }
}

extension ProductListController {
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let threshold: CGFloat = 100.0
        let contentHeight = scrollView.contentSize.height
        let offsetY = scrollView.contentOffset.y
        let height = scrollView.frame.size.height

        if offsetY > contentHeight - height - threshold && !isLoadingMore {
            isLoadingMore = true
            coordinator.loadMoreProducts()
        }
    }
    
    func appendProducts(_ newProducts: [SearchItem]) {
        let startIndex = productList.count
        productList.append(contentsOf: newProducts)
        let indexPaths = newProducts.enumerated().map { IndexPath(item: startIndex + $0.offset, section: 0) }
        collectionView.performBatchUpdates({
            collectionView.insertItems(at: indexPaths)
        }, completion: nil)
        isLoadingMore = false
    }
}
