//
//  LikeCollectionViewCell.swift
//  ShoppingMateApp
//
//  Created by 이윤지 on 6/14/24.
//

import UIKit
import SnapKit
import Kingfisher

class LikeCollectionViewCell: BaseCollectionViewCell {
    let imageView = UIImageView()
    let mallNameLabel = UILabel()
    let titleLabel = UILabel()
    let priceLabel = UILabel()
    let likeButton = UIButton(type: .system)
    
    var item: LikeTable?
    var onItemDeleted: (() -> Void)?
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

    func configure(with item: LikeTable) {
        self.item = item
        
        mallNameLabel.text = item.mallName
        titleLabel.text = item.title.replacingOccurrences(of: "<b>", with: "").replacingOccurrences(of: "</b>", with: "")
        
        if let price = Int(item.price) {
            let numberFormatter = NumberFormatter()
            numberFormatter.numberStyle = .decimal
            priceLabel.text = "\(numberFormatter.string(from: NSNumber(value: price))!)원"
        } else {
            priceLabel.text = "\(item.price)원"
        }

        if let imageURL = URL(string: item.image) {
            imageView.kf.setImage(with: imageURL)
        }
        
        likeButton.setImage(UIImage(named: likedImageName), for: .normal)
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
        guard let item = self.item else { return }
        let repository = LikeTableRepository()
        repository.deleteItem(item)
        onItemDeleted?()
    }
}

