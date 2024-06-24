//
//  SearchResult+Alert.swift
//  ShoppingMateApp
//
//  Created by 이윤지 on 6/24/24.
//

import UIKit
//에러 처리 얼럿
class AlertHelper {
    static func showErrorAlert(on viewController: UIViewController, message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        viewController.present(alert, animated: true, completion: nil)
    }
}

//닉네임 설정 얼럿
class AlertHelperProfileSettingView {
    static func showErrorAlert(on viewController: UIViewController, title: String = "경고", message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .default, handler: nil))
        viewController.present(alert, animated: true, completion: nil)
    }
}
