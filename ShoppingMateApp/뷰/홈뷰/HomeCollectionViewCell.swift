//
//  HomeCollectionViewCell.swift
//  ShoppingMateApp
//
//  Created by 이윤지 on 6/14/24.
//
//

import UIKit
import SnapKit
import Kingfisher

class HomeCollectionViewCell: UICollectionViewCell {
    private let imageView = UIImageView()
    private let mallNameLabel = UILabel()
    private let titleLabel = UILabel()
    private let priceLabel = UILabel()
    private let likeButton = UIButton(type: .system)
    
    private var item: Item?
    private var isInCart: Bool = false {
        didSet {
            updateLikeButtonImage()
        }
    }
    
    private let likedImageName = "like_selected"
    private let unlikedImageName = "like_unselected"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureView()
        NotificationCenter.default.addObserver(self, selector: #selector(handleLikeStatusChanged), name: NSNotification.Name("LikeStatusChanged"), object: nil)
       
    }
    
    @objc private func handleLikeStatusChanged(notification: NSNotification) {
        loadLikeStatus()
    }

    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureView() {
        setupUI()
        setConstraints()
        setupActions()
    }
    
    func configure(with item: Item) {
        self.item = item
        updateUI()
        loadLikeStatus()
    }
    
    private func setupUI() {
        imageView.setupImageView()
        [mallNameLabel, titleLabel, priceLabel].forEach { label in
            contentView.addSubview(label)
        }
        likeButton.setupLikeButton(unlikedImageName: unlikedImageName)
        contentView.addSubview(imageView)
        contentView.addSubview(likeButton)
    }
    
    private func setupActions() {
        likeButton.addTarget(self, action: #selector(toggleLike), for: .touchUpInside)
    }
    
    @objc private func toggleLike() {
        isInCart.toggle()
        saveLikedStatus()
        NotificationCenter.default.post(name: NSNotification.Name("LikeStatusChanged"), object: item)
    }
    
    private func updateUI() {
        guard let item = item else { return }
        
        mallNameLabel.text = item.mallName
        mallNameLabel.textColor = .customGray4C4C
        titleLabel.text = item.title.cleanedTitle()
        titleLabel.numberOfLines = 2
        priceLabel.text = item.formattedPrice()
        priceLabel.font = UIFont.systemFont(ofSize: priceLabel.font.pointSize, weight: .heavy)
        
        if let imageURL = URL(string: item.image) {
            imageView.kf.setImage(with: imageURL)
        }
    }
    
    private func loadLikeStatus() {
        guard let item = item else { return }
        let likedItems = FileManagerHelper.shared.loadLikedItems()
        isInCart = likedItems.contains { $0.title == item.title }
    }
    
    private func updateLikeButtonImage() {
        likeButton.setImage(UIImage(named: isInCart ? likedImageName : unlikedImageName)?.withRenderingMode(.alwaysOriginal), for: .normal)
        likeButton.backgroundColor = isInCart ? .customWhite : .customLightGrayCDCD.withAlphaComponent(0.5)
    }
    
    private func saveLikedStatus() {
        guard let item = item else { return }
        var likedItems = FileManagerHelper.shared.loadLikedItems()
        
        if         isInCart {
            likedItems.append(LikedItem(mall: item.mallName, imageName: item.image, title: item.title, price: item.lprice))
        } else {
            likedItems.removeAll { $0.title == item.title }
        }
        
        FileManagerHelper.shared.saveLikedItems(likedItems)
        FileManagerHelper.shared.printLikedItemsCount()
    }
}

private extension UIImageView {
    func setupImageView() {
        contentMode = .scaleToFill
        layer.cornerRadius = 15
        clipsToBounds = true
    }
}

private extension UIButton {
    func setupLikeButton(unlikedImageName: String) {
        if let unlikedImage = UIImage(named: unlikedImageName)?.withRenderingMode(.alwaysOriginal) {
            setImage(unlikedImage, for: .normal)
        }
        backgroundColor = .customLightGrayCDCD.withAlphaComponent(0.5)
        tintColor = .customWhite
        layer.cornerRadius = 18
        clipsToBounds = true
    }
}

private extension String {
    func cleanedTitle() -> String {
        return replacingOccurrences(of: "<b>", with: "").replacingOccurrences(of: "</b>", with: "")
    }
}

private extension Item {
    func formattedPrice() -> String {
        guard let price = Int(lprice) else {
            return "\(lprice)원"
        }
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        return "\(numberFormatter.string(from: NSNumber(value: price))!)원"
    }
}

private extension HomeCollectionViewCell {
    
    private func setConstraints() {
        imageView.snp.makeConstraints { make in
            make.horizontalEdges.top.equalToSuperview()
            make.height.equalTo(170)
        }
        [mallNameLabel, titleLabel, priceLabel].forEach { label in
            label.snp.makeConstraints { make in
                make.leading.trailing.equalToSuperview().inset(7)
            }
        }
        mallNameLabel.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(3)
            make.height.equalTo(20)
        }
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(mallNameLabel.snp.bottom).offset(3)
        }
        priceLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(3)
            make.height.equalTo(20)
        }
        likeButton.snp.makeConstraints { make in
            make.bottom.trailing.equalTo(imageView).inset(8)
            make.size.equalTo(36)
        }
        
    }
}
