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
    
}


class ProfileTableViewCell: UITableViewCell {
    private let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.layer.cornerRadius = 35
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 4
        imageView.layer.borderColor = UIColor.orange.cgColor
        return imageView
    }()
    
    private let usernameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 18)
        return label
    }()
    
    private let joinDateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .gray
        return label
    }()
    
    private let disclosureIndicator: UIImageView = {
        let imageView = UIImageView(image: UIImage(systemName: "chevron.right"))
        imageView.tintColor = .gray
        return imageView
    }()
    
    func configure() {
        let defaults = UserDefaults.standard
        let nickname = defaults.string(forKey: "UserNickname") ?? "닉네임이 설정되지 않음"
        let profileImageName = defaults.string(forKey: "UserProfileImage") ?? "profile_default"
        let joinDate = defaults.string(forKey: "UserJoinDate") ?? "가입 날짜가 설정되지 않음"
        
        usernameLabel.text = nickname
        joinDateLabel.text = "\(joinDate) 가입"
        profileImageView.image = UIImage(named: profileImageName)
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        contentView.addSubview(profileImageView)
        contentView.addSubview(usernameLabel)
        contentView.addSubview(joinDateLabel)
        contentView.addSubview(disclosureIndicator)
    }
    
    private func setupConstraints() {
        profileImageView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(70)
        }
        
        usernameLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(23)
            make.leading.equalTo(profileImageView.snp.trailing).offset(15)
            make.trailing.equalTo(disclosureIndicator.snp.leading).offset(-10)
        }
        
        joinDateLabel.snp.makeConstraints { make in
            make.top.equalTo(usernameLabel.snp.bottom).offset(5)
            make.leading.equalTo(usernameLabel.snp.leading)
            make.trailing.equalTo(usernameLabel.snp.trailing)
        }
        
        disclosureIndicator.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-20)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(20)
        }
    }
}



