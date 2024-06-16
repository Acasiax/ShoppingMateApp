//
//  SettingViewController.swift
//  ShoppingMateApp
//
//  Created by 이윤지 on 6/15/24.
//
import UIKit
import SnapKit
import RealmSwift

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
            return nil
        default:
            return nil
        }
    }
}

class SettingViewController: UIViewController {
    
    private let tableView = UITableView(frame: .zero, style: .plain)
    
    
    var likedItemsCount: Int = 0 {
        didSet {
            tableView.reloadData()
        }
    }
    private var notificationToken: NotificationToken?

    
    private var navigationTitle: String
        private var showSaveButton: Bool

        init(navigationTitle: String, showSaveButton: Bool) {
            self.navigationTitle = navigationTitle
            self.showSaveButton = showSaveButton
            super.init(nibName: nil, bundle: nil)
        }

        required init?(coder: NSCoder) {
            self.navigationTitle = ""
            self.showSaveButton = false
            super.init(coder: coder)
        }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupNavigationBar()
        setupTableView()
        setupConstraints()
        observeLikedItems()
    }
    
    deinit {
        notificationToken?.invalidate()
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
    
    private func observeLikedItems() {
        let repository = LikeTableRepository()
        let likedItems = repository.fetchAll()
        notificationToken = likedItems.observe { [weak self] changes in
            switch changes {
            case .initial, .update:
                self?.updateLikedItemsCount()
            case .error(let error):
                print("Error observing liked items: \(error)")
            }
        }
    }
    
    private func updateLikedItemsCount() {
        let repository = LikeTableRepository()
        likedItemsCount = repository.fetchAll().count
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

            // 모든 서브뷰를 제거합니다
            cell.contentView.subviews.forEach { $0.removeFromSuperview() }

            if settingOption == .cart {
                let cartImageView = UIImageView(image: UIImage(systemName: "cart"))
                cartImageView.tintColor = .black
                let cartLabel = UILabel()
                cartLabel.text = "\(likedItemsCount)개의 상품"
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
                    if let navigationController = self.navigationController {
                        navigationController.pushViewController(profileVC, animated: true)
                    } else {
                        print("Navigation controller not found")
                    }
            case .cart:
                let likeVC = LikeViewController()
                            if let navigationController = self.navigationController {
                                navigationController.pushViewController(likeVC, animated: true)
                            } else {
                                print("Navigation controller not found")
                            }
                
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
    
    //👮‍♀️
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
