//
//  Create+Component222.swift
//  ShoppingMateApp
//
//  Created by 이윤지 on 6/17/24.
//
import UIKit

extension UIView {
    func createButton(title: String, width: CGFloat = 55) -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle(title, for: .normal)
        button.setTitleColor(.customGray4C4C, for: .normal)
        button.backgroundColor = .clear
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 15
        button.layer.borderColor =  UIColor.customGray4C4C.cgColor
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        button.snp.makeConstraints { make in
            make.width.equalTo(width)
            make.height.equalTo(38)
        }
        return button
    }

    func createSearchBar(delegate: UISearchBarDelegate?) -> UISearchBar {
        let searchBar = UISearchBar()
        searchBar.placeholder = "브랜드, 상품 등을 입력하세요."
        searchBar.searchBarStyle = .minimal
        //searchBar.layer.shadowColor = UIColor.clear.cgColor
        searchBar.showsCancelButton = true
        searchBar.searchTextField.textColor = .customBlack
        searchBar.delegate = delegate
        if let cancelButton = searchBar.value(forKey: "cancelButton") as? UIButton {
            cancelButton.setTitle("취소", for: .normal)
            cancelButton.titleLabel?.font = UIFont.systemFont(ofSize: 16)
            cancelButton.tintColor = .customOrange
        }
        return searchBar
    }
}




