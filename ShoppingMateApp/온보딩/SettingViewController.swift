//
//  SettingViewController.swift
//  ShoppingMateApp
//
//  Created by 이윤지 on 6/15/24.
//

import UIKit
import SnapKit

enum SettingOption: Int, CaseIterable {
    case profile
    case cart
    case faq
    case inquiry
    case notifications
    case logout
    
    var title: String {
        switch self {
        case .profile:
            return "웅골찬 고래밥"
        case .cart:
            return "나의 장바구니 목록"
        case .faq:
            return "자주 묻는 질문"
        case .inquiry:
            return "1:1 문의"
        case .notifications:
            return "알림 설정"
        case .logout:
            return "탈퇴하기"
        }
    }
    
    var detail: String? {
        switch self {
        case .profile:
            return nil
        case .cart:
            return "18개의 상품"
        default:
            return nil
        }
    }
}


class SettingViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
      
    }
    

}


