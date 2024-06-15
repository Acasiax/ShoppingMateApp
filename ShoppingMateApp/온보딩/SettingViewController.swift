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
    func numberOfSections(in tableView: UITableView) -> Int {
        return SettingOption.allCases.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let settingOption = SettingOption(rawValue: indexPath.section) else {
            return UITableViewCell()
        }
        
        switch settingOption {
        case .profile:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileCell", for: indexPath) as? ProfileTableViewCell else {
                return UITableViewCell()
            }
            cell.configure()
            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "SettingCell", for: indexPath)
            cell.textLabel?.text = settingOption.title
            cell.detailTextLabel?.text = settingOption.detail
            cell.accessoryType = settingOption == .logout ? .none : .disclosureIndicator
            cell.textLabel?.textColor = settingOption == .logout ? .red : .black
            if settingOption == .cart {
                let cartImageView = UIImageView(image: UIImage(systemName: "cart"))
                cartImageView.tintColor = .black
                let cartLabel = UILabel()
                cartLabel.text = settingOption.detail
                cartLabel.textColor = .black
                
                cell.contentView.addSubview(cartImageView)
                cell.contentView.addSubview(cartLabel)
                
                cartImageView.snp.makeConstraints { make in
                    make.trailing.equalToSuperview().offset(-10)
                    make.centerY.equalToSuperview()
                    make.width.height.equalTo(24)
                }
                
                cartLabel.snp.makeConstraints { make in
                    make.trailing.equalTo(cartImageView.snp.leading).offset(-5)
                    make.centerY.equalToSuperview()
                }
            }
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let settingOption = SettingOption(rawValue: indexPath.section)
        return settingOption == .profile ? 100 : 44
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if let settingOption = SettingOption(rawValue: indexPath.section) {
            switch settingOption {
            case .profile:
                let profileVC = ProfileSettingViewController(navigationTitle: "Edit Profile", showSaveButton: true)
                navigationController?.pushViewController(profileVC, animated: true)
            case .logout:
                showLogoutAlert()
            default:
                break
            }
        }
    }
    
    private func showLogoutAlert() {
        let alert = UIAlertController(title: "탈퇴하기", message: "정말로 탈퇴하시겠습니까?", preferredStyle: .alert)
        let confirmAction = UIAlertAction(title: "확인", style: .destructive) { _ in
            self.resetUserDefaults()
            self.navigateToOnboarding()
        }
        let cancelAction = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        
        alert.addAction(confirmAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    private func resetUserDefaults() {
        let defaults = UserDefaults.standard
        let dictionary = defaults.dictionaryRepresentation()
        dictionary.keys.forEach { key in
            defaults.removeObject(forKey: key)
        }
    }
    
    private func navigateToOnboarding() {
        let onboardingVC = OnboardingView()
        let navigationController = UINavigationController(rootViewController: onboardingVC)
        if let window = UIApplication.shared.windows.first {
            window.rootViewController = navigationController
            window.makeKeyAndVisible()
            UIView.transition(with: window, duration: 0.5, options: .transitionCrossDissolve, animations: nil, completion: nil)
        }
    }
}






