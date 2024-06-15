//
//  ProfileCell.swift
//  ShoppingMateApp
//
//  Created by 이윤지 on 6/15/24.
//

import UIKit

class ProfileCell: UICollectionViewCell {
    
    static let id = "ProfileCell"
    
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        //imageView.alpha = 0.5 // 이미지 반투명 설정
        imageView.layer.cornerRadius = 40
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 1
        imageView.layer.borderColor = UIColor.gray.cgColor
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
           super.prepareForReuse()
           imageView.layer.borderColor = UIColor.gray.cgColor // 🟠
           imageView.layer.borderWidth = 1 // 🟠
           imageView.alpha = 0.5 // 🟠
       }
}
