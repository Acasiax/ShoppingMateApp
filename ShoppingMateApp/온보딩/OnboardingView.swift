//
//  OnboardingView.swift
//  ShoppingMateApp
//
//  Created by 이윤지 on 6/15/24.
//

import UIKit
import SnapKit

class OnboardingView: UIViewController {
    private let titleLabel: UILabel = {
           let label = UILabel()
           label.text = "MeaningOut"
           label.font = UIFont.systemFont(ofSize: 45, weight: .heavy)
           label.textColor = UIColor.orange
           label.textAlignment = .center
           return label
       }()
    
    private let launchImageView: UIImageView = {
            let imageView = UIImageView()
            imageView.image = UIImage(named: "launch")
            imageView.contentMode = .scaleAspectFill
            return imageView
        }()
    
    private let startButton: UIButton = {
            let button = UIButton(type: .system)
            button.setTitle("시작하기", for: .normal)
            button.backgroundColor = .orange
            button.setTitleColor(.white, for: .normal)
            button.layer.cornerRadius = 8
            return button
        }()
    
}
