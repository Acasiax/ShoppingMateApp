//
//  HomeCollectionViewCell.swift
//  ShoppingMateApp
//
//  Created by 이윤지 on 6/14/24.
//

import UIKit
import SnapKit
import RealmSwift
import Kingfisher

class HomeCollectionViewCell: BaseCollectionViewCell {
    let imageView = UIImageView()
    let mallNameLabel = UILabel()
    let titleLabel = UILabel()
    let priceLabel = UILabel()
    let likeButton = UIButton(type: .system)
    var isLiked: Bool = false {
        didSet {
            updateLikeButtonImage()
        }
    }
    
    var item: Item?
    
    private let likedImageName = "like_selected"
    private let unlikedImageName = "like_unselected"
    
    func configure(with item: Item) {
        self.item = item
        
        mallNameLabel.text = item.mallName
        titleLabel.text = item.title.replacingOccurrences(of: "<b>", with: "").replacingOccurrences(of: "</b>", with: "")
        
        if let price = Int(item.lprice) {
            let numberFormatter = NumberFormatter()
            numberFormatter.numberStyle = .decimal
            priceLabel.text = "\(numberFormatter.string(from: NSNumber(value: price))!)원"
        } else {
            priceLabel.text = "\(item.lprice)원"
        }
        
        if let imageURL = URL(string: item.image) {
            imageView.kf.setImage(with: imageURL)
        }
        
        let repository = LikeTableRepository()
        isLiked = repository.fetchAll().contains { $0.title == item.title }
       
       
    }
    
    override func configureView() {
        likeButton.addTarget(self, action: #selector(toggleLike), for: .touchUpInside)
    }
    
    
    private func setupUI() {
        imageView.contentMode = .scaleToFill
        imageView.layer.cornerRadius = 15
        imageView.clipsToBounds = true
        
        mallNameLabel.textColor = .gray
        mallNameLabel.font = UIFont.systemFont(ofSize: 15)
        mallNameLabel.textAlignment = .left
        
        titleLabel.textColor = .white
        titleLabel.font = UIFont.systemFont(ofSize: 16)
        titleLabel.textAlignment = .left
        titleLabel.numberOfLines = 2
        titleLabel.setContentHuggingPriority(.defaultHigh, for: .vertical)
        
        priceLabel.textColor = .white
        priceLabel.font = UIFont.boldSystemFont(ofSize: 18)
        priceLabel.textAlignment = .left
        
        likeButton.setImage(UIImage(named: unlikedImageName), for: .normal)
        likeButton.backgroundColor = .orange
        likeButton.tintColor = .brown
        likeButton.layer.cornerRadius = 18
        likeButton.clipsToBounds = true
        
        contentView.addSubview(imageView)
        contentView.addSubview(mallNameLabel)
        contentView.addSubview(titleLabel)
        contentView.addSubview(priceLabel)
        contentView.addSubview(likeButton)
    }
    
    @objc private func toggleLike() {
        isLiked.toggle()
     
    }
    
    private func updateLikeButtonImage() {
        let imageName = isLiked ? likedImageName : unlikedImageName
        likeButton.setImage(UIImage(named: imageName), for: .normal)
    }
}
