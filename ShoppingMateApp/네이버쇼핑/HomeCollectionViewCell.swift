//
//  HomeCollectionViewCell.swift
//  ShoppingMateApp
//
//  Created by 이윤지 on 6/14/24.
//

import UIKit
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
        
       
       
    }
    
    override func configureView() {
        likeButton.addTarget(self, action: #selector(toggleLike), for: .touchUpInside)
    }
    
    @objc private func toggleLike() {
        isLiked.toggle()
     
    }
    
    private func updateLikeButtonImage() {
        let imageName = isLiked ? likedImageName : unlikedImageName
        likeButton.setImage(UIImage(named: imageName), for: .normal)
    }
}
