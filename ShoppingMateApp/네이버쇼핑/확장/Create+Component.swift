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
       
        }
        return button
    }


}
