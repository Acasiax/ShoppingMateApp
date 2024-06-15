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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupViews()
        setupConstraints()
    }
    
    private func setupViews() {
        view.addSubview(titleLabel)
        view.addSubview(launchImageView)
        view.addSubview(startButton)
    }
    private func setupConstraints() {
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(40)
            make.centerX.equalToSuperview()
        }
        
        launchImageView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.6)
            make.height.equalTo(launchImageView.snp.width).multipliedBy(1.2)
        }
        
        startButton.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-40)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.8)
            make.height.equalTo(50)
        }
    }
    
    @objc private func startButtonTapped() {
        let profileSettingVC = ProfileSettingViewController(navigationTitle: "PROFILE SETTING", showSaveButton: false)
        navigationController?.pushViewController(profileSettingVC, animated: true)
    }

    
}
