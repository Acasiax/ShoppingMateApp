//
//  Create+Component.swift
//  ShoppingMateApp
//
//  Created by 이윤지 on 6/14/24.
//

import UIKit

extension UIView {
    func createButton(title: String, width: CGFloat = 55) -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle(title, for: .normal)
        button.setTitleColor(.gray, for: .normal)
        button.backgroundColor = .clear
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 15
        button.layer.borderColor = UIColor.gray.cgColor
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        button.snp.makeConstraints { make in
            make.width.equalTo(width)
            make.height.equalTo(40)
        }
        return button
    }


}
