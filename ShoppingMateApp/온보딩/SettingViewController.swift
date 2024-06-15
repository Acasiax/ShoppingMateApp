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
    private let tableView = UITableView(frame: .zero, style: .plain)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupNavigationBar()
                setupTableView()
                setupConstraints()
    }
    private func setupNavigationBar() {
           navigationItem.title = "SETTING"
           navigationController?.navigationBar.titleTextAttributes = [.font: UIFont.boldSystemFont(ofSize: 18)]
       }
       
       private func setupTableView() {
           tableView.delegate = self
           tableView.dataSource = self
           tableView.separatorInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
           tableView.backgroundColor = .white
           tableView.register(UITableViewCell.self, forCellReuseIdentifier: "SettingCell")
           tableView.register(ProfileTableViewCell.self, forCellReuseIdentifier: "ProfileCell")
           view.addSubview(tableView)
       }
       
       private func setupConstraints() {
           tableView.snp.makeConstraints { make in
               make.edges.equalToSuperview()
           }
       }

}


extension SettingViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        <#code#>
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        <#code#>
    }
    
    
    
    
}
