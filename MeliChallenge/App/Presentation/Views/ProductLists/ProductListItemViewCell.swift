//
//  ProductListItemViewCell.swift
//  MeliChallenge
//
//  Created by Harold Padilla on 20/10/24.
//

import UIKit

final class ProductListItemViewCell: UICollectionViewCell {
    
    private let mainContainer: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGroupedBackground
        view.layer.cornerRadius = 10
        view.layer.masksToBounds = true
        return view
    }()
    
    private let productImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .subheadline)
        label.numberOfLines = 2
        return label
    }()
    
    private let priceLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .headline)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configUI() {
        addSubview(mainContainer)
        mainContainer.fillSuperView(widthPadding: 10)
        
        mainContainer.addSubview(titleLabel)
        titleLabel.setConstraints(
            right: mainContainer.rightAnchor,
            bottom: mainContainer.bottomAnchor,
            left: mainContainer.leftAnchor,
            pRight: 10,
            pBottom: 10,
            pLeft: 10
        )
        
        mainContainer.addSubview(priceLabel)
        priceLabel.setConstraints(
            bottom: titleLabel.topAnchor,
            left: mainContainer.leftAnchor,
            pRight: 10,
            pLeft: 10
        )
        
        mainContainer.addSubview(productImageView)
        productImageView.setConstraints(
            top: mainContainer.topAnchor,
            right: mainContainer.rightAnchor,
            left: mainContainer.leftAnchor,
            pBottom: 10
        )
        productImageView.setHeight((AppConstants.widthScreen - 60) / 2)
    }
    
    func configure(with viewModel: SearchItem) {
        titleLabel.text = viewModel.title
        priceLabel.text = viewModel.price.formattedAsCurrency() ?? "$\(viewModel.price)"
        
        productImageView.loadImage(from: viewModel.thumbnail, placeholder: UIImage(named: "placeholder"))
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        productImageView.image = UIImage(named: "placeholder")
    }
}

extension ProductListItemViewCell: Reusable {}
