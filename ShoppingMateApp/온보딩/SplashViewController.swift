//
//  SplashViewController.swift
//  ShoppingMateApp
//
//  Created by 이윤지 on 6/17/24.
//
import UIKit
import SnapKit

class SplashViewController: UIViewController {
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "MeaningOut"
        label.font = UIFont.systemFont(ofSize: 45, weight: .heavy)
        label.textColor = .customOrange
        label.textAlignment = .center
        return label
    }()
    
    private let launchImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "launch")
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.text = "이윤지(스플래쉬)"
        label.font = UIFont.systemFont(ofSize: 27, weight: .bold)
        label.textColor = .customOrange
        label.textAlignment = .center
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .customWhite
        setupViews()
        setupConstraints()
    }
    
    private func setupViews() {
        view.addSubview(titleLabel)
        view.addSubview(launchImageView)
        view.addSubview(nameLabel)  // nameLabel 추가
    }
    
    private func setupConstraints() {
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(73)
            make.centerX.equalToSuperview()
        }
        
        launchImageView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
           // make.width.equalToSuperview().multipliedBy(0.6)
           // make.height.equalTo(launchImageView.snp.width).multipliedBy(1.2)
        }
        
        nameLabel.snp.makeConstraints { make in
            make.top.equalTo(launchImageView.snp.bottom).offset(30)
            make.centerX.equalToSuperview()
        }
    }
}
