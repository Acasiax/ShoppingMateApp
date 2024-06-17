//
//  HomeCollectionViewCell.swift
//  ShoppingMateApp
//
//  Created by 이윤지 on 6/14/24.
//

import UIKit
import SnapKit
import Kingfisher
import RealmSwift

class HomeCollectionViewCell: BaseCollectionViewCell {
    let imageView = UIImageView()
    let mallNameLabel = UILabel()
    let titleLabel = UILabel()
    let priceLabel = UILabel()
    let likeButton = UIButton(type: .system)
    
    var item: Item?
    var isLiked: Bool = false {
        didSet {
            updateLikeButtonImage()
        }
    }
    
    private let likedImageName = "like_selected"
    private let unlikedImageName = "like_unselected"
    
    override func configureView() {
        setupUI()
        likeButton.addTarget(self, action: #selector(toggleLike), for: .touchUpInside)
    }
    
    override func setConstraints() {
        imageView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview()
            make.top.equalToSuperview()
            make.height.equalTo(170)
        }
        mallNameLabel.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(3)
            make.leading.equalToSuperview().offset(7)
            make.trailing.equalToSuperview().offset(-7)
            make.height.equalTo(20)
        }
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(mallNameLabel.snp.bottom).offset(3)
            make.leading.equalToSuperview().offset(7)
            make.trailing.equalToSuperview().offset(-7)
        }
        priceLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(3)
            make.leading.equalToSuperview().offset(7)
            make.trailing.equalToSuperview().offset(-7)
            make.height.equalTo(20)
        }
        likeButton.snp.makeConstraints { make in
            make.bottom.equalTo(imageView.snp.bottom).inset(8)
            make.trailing.equalTo(imageView.snp.trailing).offset(-8)
            make.size.equalTo(36)
        }
    }
    
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
    
    
    
    private func setupUI() {
        imageView.contentMode = .scaleToFill
        imageView.layer.cornerRadius = 15
        imageView.clipsToBounds = true
        
        mallNameLabel.textColor = .customGray4C4C
        mallNameLabel.font = UIFont.systemFont(ofSize: 15)
        mallNameLabel.textAlignment = .left
        
        titleLabel.textColor = .customBlack
        titleLabel.font = UIFont.systemFont(ofSize: 16)
        titleLabel.textAlignment = .left
        titleLabel.numberOfLines = 2
        titleLabel.setContentHuggingPriority(.defaultHigh, for: .vertical)
        
        priceLabel.textColor = .customBlack
        priceLabel.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        priceLabel.textAlignment = .left
        
        if let unlikedImage = UIImage(named: unlikedImageName)?.withRenderingMode(.alwaysOriginal) {
               likeButton.setImage(unlikedImage, for: .normal)
           }
        
        
        likeButton.backgroundColor = .customLightGrayCDCD.withAlphaComponent(0.5)
        likeButton.tintColor = .customWhite
        likeButton.layer.cornerRadius = 18
        likeButton.clipsToBounds = true
        
        contentView.addSubview(imageView)
        contentView.addSubview(mallNameLabel)
        contentView.addSubview(titleLabel)
        contentView.addSubview(priceLabel)
        contentView.addSubview(likeButton)
    }
    
//    @objc private func toggleLike() {
//        isLiked.toggle()
//        guard let item = self.item else { return }
//        let repository = LikeTableRepository()
//        if isLiked {
//              repository.saveItem(item)
//              NotificationCenter.default.post(name: NSNotification.Name("LikeStatusChanged"), object: nil) // ⭐️
//          } else {
//              repository.deleteItem(item)
//              NotificationCenter.default.post(name: NSNotification.Name("LikeStatusChanged"), object: nil) // ⭐️
//          }
//      }
    
    
    //Invalidating grant <invalid NS/CF object> failed 오류 나서 수정함
    @objc private func toggleLike() {
        isLiked.toggle()
        guard let item = self.item else { return }
        let repository = LikeTableRepository()
        
        if isLiked {
            repository.saveItem(item)
        } else {
            repository.deleteItem(item)
        }
        
        NotificationCenter.default.post(name: NSNotification.Name("LikeStatusChanged"), object: nil) // ⭐️
    }

    
    
    private func updateLikeButtonImage() {
        let imageName = isLiked ? likedImageName : unlikedImageName
            if let image = UIImage(named: imageName)?.withRenderingMode(.alwaysOriginal) {
                likeButton.setImage(image, for: .normal)
            }
            likeButton.backgroundColor = isLiked ? .customWhite : .customLightGrayCDCD.withAlphaComponent(0.5)
       
    }
}
