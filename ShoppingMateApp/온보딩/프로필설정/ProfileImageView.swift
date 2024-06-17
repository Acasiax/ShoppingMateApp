//
//  ProfileImageView.swift
//  ShoppingMateApp
//
//  Created by 이윤지 on 6/15/24.
//

import UIKit
import SnapKit

class ProfileImageView: UIView {
    
    let imageView: UIImageView = {
        let imageView = UIImageView()
        let profileImages = ["profile_0", "profile_1", "profile_2", "profile_3", "profile_4", "profile_5", "profile_6", "profile_7", "profile_8", "profile_9", "profile_10", "profile_11"]
        let randomImageName = profileImages.randomElement() ?? "profile_0"
        imageView.image = UIImage(named: randomImageName)
        imageView.contentMode = .scaleAspectFit
        imageView.layer.cornerRadius = 50
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 4
        imageView.layer.borderColor = UIColor.customOrange.cgColorValue
        return imageView
    }()
    
    let cameraBackgroundView: UIView = {
          let view = UIView()
          view.backgroundColor = .customOrange
          view.layer.cornerRadius = 17
          view.layer.masksToBounds = true
          return view
      }()
    
    let cameraIconView: UIImageView = {
          let imageView = UIImageView()
          imageView.image = UIImage(systemName: "camera.fill")
          imageView.tintColor = .customWhite
        imageView.layer.masksToBounds = true
          return imageView
      }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        addSubview(imageView)
        addSubview(cameraBackgroundView)
        cameraBackgroundView.addSubview(cameraIconView)
        
    }
    private func setupConstraints() {
           imageView.snp.makeConstraints { make in
               make.edges.equalToSuperview()
               
           }
           
        cameraBackgroundView.snp.makeConstraints { make in
                    make.bottom.equalTo(imageView.snp.bottom)
                    make.right.equalTo(imageView.snp.right)
                    make.width.height.equalTo(30)
                }
        
           cameraIconView.snp.makeConstraints { make in
               make.center.equalTo(cameraBackgroundView)
               make.width.height.equalTo(18)
           }
       }
}
