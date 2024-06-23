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


//웹뷰 네비
extension UINavigationBar {
    func applyCustomAppearance(backgroundColor: UIColor, titleColor: UIColor, tintColor: UIColor) {
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = backgroundColor
        appearance.titleTextAttributes = [.foregroundColor: titleColor]
        
        self.isTranslucent = false
        self.scrollEdgeAppearance = appearance
        self.standardAppearance = appearance
        self.tintColor = tintColor
    }
}

//웹뷰 네비
extension UIViewController {
    func configureNavigationBar(title: String?, rightButtonImage: UIImage?, rightButtonAction: Selector, leftButtonAction: Selector) {
        navigationItem.title = title
        
        if let rightButtonImage = rightButtonImage {
            navigationItem.rightBarButtonItem = UIBarButtonItem(image: rightButtonImage, style: .plain, target: self, action: rightButtonAction)
        }
        
        let backButton = UIButton(type: .system)
        backButton.setImage(UIImage(systemName: "chevron.backward"), for: .normal)
        backButton.addTarget(self, action: leftButtonAction, for: .touchUpInside)
        backButton.tintColor = UIColor.customBlack
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)
    }
}
