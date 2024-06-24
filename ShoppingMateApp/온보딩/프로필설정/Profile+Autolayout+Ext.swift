//
//  Profile+Autolayout+Ext.swift
//  ShoppingMateApp
//
//  Created by 이윤지 on 6/24/24.
//

import UIKit
import SnapKit

extension ProfileSettingViewController {

    func setupConstraints() {
        profileImageView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(40)
            make.centerX.equalToSuperview()
            make.width.height.equalTo(100)
        }
        
        contentView.snp.makeConstraints { make in
            make.top.equalTo(profileImageView.snp.bottom).offset(20)
            make.left.right.bottom.equalToSuperview()
        }
        
        nicknameTextField.snp.makeConstraints { make in
            make.top.equalTo(contentView.snp.top).offset(35)
            make.left.equalToSuperview().offset(40)
            make.right.equalToSuperview().offset(-40)
        }
        
        bottomLineView.snp.makeConstraints { make in
            make.top.equalTo(nicknameTextField.snp.bottom).offset(10)
            make.left.equalToSuperview().offset(40)
            make.right.equalToSuperview().offset(-40)
            make.height.equalTo(1)
        }
        noteLabel.snp.makeConstraints { make in
            make.top.equalTo(bottomLineView.snp.bottom).offset(10)
            make.left.equalToSuperview().offset(45)
        }
        
        if showCompleteButton {
            completeButton.snp.makeConstraints { make in
                make.top.equalTo(noteLabel.snp.bottom).offset(30)
                make.left.equalToSuperview().offset(40)
                make.right.equalToSuperview().offset(-40)
                make.height.equalTo(50)
            }
        }
        
        if showPassButton {
            passButton.snp.makeConstraints { make in
                make.top.equalTo(completeButton.snp.bottom).offset(10)
                make.left.equalToSuperview().offset(40)
                make.right.equalToSuperview().offset(-40)
                make.height.equalTo(50)
            }
        }
    }
}

