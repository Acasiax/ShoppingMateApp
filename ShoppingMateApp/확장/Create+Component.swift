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
            make.height.equalTo(40)
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


// "완료","로그인 없이 둘러볼게요 버튼" UIButton에 applyCustomStyle 확장 메서드 추가
extension UIButton {
    func applyCustomStyle(title: String, fontSize: CGFloat, cornerRadius: CGFloat, backgroundColor: UIColor, titleColor: UIColor) {
        self.setTitle(title, for: .normal)
        self.titleLabel?.font = .systemFont(ofSize: fontSize, weight: .heavy)
        self.backgroundColor = backgroundColor
        self.layer.cornerRadius = cornerRadius
        self.setTitleColor(titleColor, for: .normal)
    }
}


extension UINavigationController {
    
    func configureAppearance(withTitle title: String?, rightBarButtonImage: UIImage?, rightBarButtonAction: Selector, target: Any, leftBarButtonImage: UIImage?, leftBarButtonAction: Selector) {
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = .customWhite
        appearance.titleTextAttributes = [.foregroundColor: UIColor.customBlack]
        navigationBar.isTranslucent = false
        navigationBar.scrollEdgeAppearance = appearance
        navigationBar.standardAppearance = appearance
        navigationBar.tintColor = .customBlack
        
        let rightBarButtonItem = UIBarButtonItem(image: rightBarButtonImage, style: .plain, target: target, action: rightBarButtonAction)
        let leftBarButton = UIButton(type: .system)
        leftBarButton.setImage(leftBarButtonImage, for: .normal)
        leftBarButton.addTarget(target, action: leftBarButtonAction, for: .touchUpInside)
        leftBarButton.tintColor = UIColor.customBlack
        let leftBarButtonItem = UIBarButtonItem(customView: leftBarButton)
        
        if let topItem = navigationBar.topItem {
            topItem.rightBarButtonItem = rightBarButtonItem
            topItem.leftBarButtonItem = leftBarButtonItem
            topItem.title = title
        }
    }
}
