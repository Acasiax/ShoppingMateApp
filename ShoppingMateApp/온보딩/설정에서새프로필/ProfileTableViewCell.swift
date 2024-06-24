//
//  ProfileTableViewCell.swift
//  ShoppingMateApp
//
//  Created by 이윤지 on 6/15/24.
//

import UIKit
import SnapKit

class ProfileTableViewCell: UITableViewCell {
    private let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.layer.cornerRadius = 35
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 4
        imageView.layer.borderColor = UIColor.customOrange.cgColorValue
        return imageView
    }()
    
    private let usernameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 16)
        return label
    }()
    
    private let joinDateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .customGray4C4C
        return label
    }()
    
    private let disclosureIndicator: UIImageView = {
        let imageView = UIImageView(image: UIImage(systemName: "chevron.right"))
        imageView.tintColor = .customGray4C4C
        return imageView
    }()
    
    func configure() {
        let defaults = UserDefaults.standard
        let nickname = defaults.string(forKey: "UserNickname") ?? "닉네임이 설정되지 않음"
        let joinDate = defaults.string(forKey: "UserJoinDate") ?? "가입 날짜가 설정되지 않음"
        
        usernameLabel.text = nickname
        joinDateLabel.text = "\(joinDate) 가입"
        
        if let imageData = defaults.data(forKey: "UserProfileImage"), let profileImage = UIImage(data: imageData) {
            profileImageView.image = profileImage
        } else {
            profileImageView.image = UIImage(named: "profile_5")
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        contentView.addSubview(profileImageView)
        contentView.addSubview(usernameLabel)
        contentView.addSubview(joinDateLabel)
        contentView.addSubview(disclosureIndicator)
    }
    
    private func setupConstraints() {
        profileImageView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(70)
        }
        
        usernameLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(23)
            make.leading.equalTo(profileImageView.snp.trailing).offset(15)
            make.trailing.equalTo(disclosureIndicator.snp.leading).offset(-10)
        }
        
        joinDateLabel.snp.makeConstraints { make in
            make.top.equalTo(usernameLabel.snp.bottom).offset(5)
            make.leading.equalTo(usernameLabel.snp.leading)
            make.trailing.equalTo(usernameLabel.snp.trailing)
        }
        
        disclosureIndicator.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-20)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(20)
        }
    }
}
