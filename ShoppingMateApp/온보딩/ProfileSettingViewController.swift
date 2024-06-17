//
//  ProfileSettingViewController.swift
//  ShoppingMateApp
//
//  Created by 이윤지 on 6/15/24.
//
import UIKit

class ProfileSettingViewController: UIViewController {
    
    private let profileImageView = ProfileImageView()
    private let contentView = UIView()
    private var currentProfileImageName: String? {
        didSet {
            saveUserData()
        }
    }

    private let nicknameTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "닉네임을 입력해주세요 :)"
        textField.borderStyle = .roundedRect
        textField.textAlignment = .center
        textField.autocorrectionType = .no
        textField.spellCheckingType = .no
        return textField
    }()
    
    private let noteLabel: UILabel = {
        let label = UILabel()
        label.text = "닉네임에 @ 는 포함할 수 없어요."
        label.textColor = .orange
        label.font = UIFont.systemFont(ofSize: 14)
        label.textAlignment = .center
        return label
    }()
    
    private let completeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("완료", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 15, weight: .heavy)
        button.backgroundColor = .orange
        button.layer.cornerRadius = 23
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private let passButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("로그인 없이 시작", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 15, weight: .heavy)
        button.backgroundColor = .orange
        button.layer.cornerRadius = 23
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(passButtonTapped), for: .touchUpInside)
        return button
    }()
    
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
        setupViews()
        setupConstraints()
        //loadUserData()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(profileImageTapped))
        profileImageView.isUserInteractionEnabled = true
        profileImageView.addGestureRecognizer(tapGesture)
        
        nicknameTextField.delegate = self
    }
    
    private func setupNavigationBar() {
        navigationItem.title = showSaveButton ? "EDIT PROFILE" : "PROFILE SETTING"
        navigationController?.navigationBar.titleTextAttributes = [.font: UIFont.boldSystemFont(ofSize: 18)]
        
        if showSaveButton {
            let saveButton = UIBarButtonItem(title: "저장", style: .plain, target: self, action: #selector(saveButtonTapped))
            saveButton.setTitleTextAttributes([.foregroundColor: UIColor.black, .font: UIFont.systemFont(ofSize: 16, weight: .black)], for: .normal)
            navigationItem.rightBarButtonItem = saveButton
        }
    }
    
    private func setupViews() {
        view.addSubview(profileImageView)
        view.addSubview(contentView)
        
        contentView.addSubview(nicknameTextField)
        contentView.addSubview(noteLabel)
        contentView.addSubview(completeButton)
        contentView.addSubview(passButton)
    }
    
    private func setupConstraints() {
        profileImageView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(40)
            make.centerX.equalToSuperview()
            make.width.height.equalTo(100)
        }
        
        contentView.snp.makeConstraints { make in
            make.top.equalTo(profileImageView.snp.bottom).offset(20)
            make.left.right.bottom.equalToSuperview()
        }
        
        nicknameTextField.snp.makeConstraints { make in
            make.top.equalTo(contentView.snp.top).offset(40)
            make.left.equalToSuperview().offset(40)
            make.right.equalToSuperview().offset(-40)
        }
        
        noteLabel.snp.makeConstraints { make in
            make.top.equalTo(nicknameTextField.snp.bottom).offset(10)
            make.left.equalToSuperview().offset(50)
           // make.right.equalToSuperview().offset(-40)
        }
        
        completeButton.snp.makeConstraints { make in
            make.top.equalTo(noteLabel.snp.bottom).offset(30)
            make.left.equalToSuperview().offset(40)
            make.right.equalToSuperview().offset(-40)
            make.height.equalTo(50)
        }
        passButton.snp.makeConstraints { make in
            make.top.equalTo(completeButton.snp.bottom).offset(10)
            make.left.equalToSuperview().offset(40)
            make.right.equalToSuperview().offset(-40)
            make.height.equalTo(50)
        }
    }
    
    @objc private func profileImageTapped() {
        // 프로필 이미지 탭 기능
        let newViewController = NewProfileSelectionViewController()
        newViewController.delegate = self
        addChild(newViewController)
        newViewController.view.frame = contentView.bounds
        contentView.addSubview(newViewController.view)
        newViewController.didMove(toParent: self)
    }
    
    @objc private func saveButtonTapped() {
        let nickname = nicknameTextField.text ?? ""
        let validationMessage = evaluateNickname(nickname: nickname)
        if validationMessage == "사용할 수 있는 닉네임이에요" {
            saveUserData()
            navigateToNextScreen()
        } else {
            // 잘못된 닉네임 경고 메시지 표시
            let alert = UIAlertController(title: "경고", message: validationMessage, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "확인", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
        }
    }
    
    @objc private func passButtonTapped() {
        saveUserData()
        navigateToNextScreen()
    }
  
    private func navigateToNextScreen() {
        let tabBarVC = UITabBarController()
        
        let homeVC = HomeViewController()
        //homeVC.navigationItem.title = "검색"
        
        let settingsVC = SettingViewController(navigationTitle: "세팅뷰우", showSaveButton: false)
        
        let likeVC = LikeViewController()
        // likeVC.navigationItem.title = "좋아요"
        
        let searchNavVC = UINavigationController(rootViewController: homeVC)
        searchNavVC.tabBarItem = UITabBarItem(title: "검색", image: UIImage(systemName: "magnifyingglass"), tag: 0)
        
        let settingsNavVC = UINavigationController(rootViewController: settingsVC)
        settingsNavVC.tabBarItem = UITabBarItem(title: "설정", image: UIImage(systemName: "gearshape"), tag: 1)
        
        let likeNavVC = UINavigationController(rootViewController: likeVC)
        likeNavVC.tabBarItem = UITabBarItem(title: "좋아요", image: UIImage(systemName: "heart"), tag: 2)
        
        tabBarVC.setViewControllers([searchNavVC, settingsNavVC, likeNavVC], animated: false)
      //  tabBarVC.modalPresentationStyle = .fullScreen
        tabBarVC.tabBar.backgroundColor = UIColor(red: 0.97, green: 0.98, blue: 0.98, alpha: 1.00)
        tabBarVC.tabBar.tintColor = .white
        tabBarVC.tabBar.unselectedItemTintColor = .gray
        
        // 탭바 아이콘 색상 설정
        tabBarVC.tabBar.tintColor = .orange // 선택된 아이템의 색상
        tabBarVC.tabBar.unselectedItemTintColor = .gray  // 선택되지 않은 아이템의 색상
        
        guard let items = tabBarVC.tabBar.items else { return }
        items[0].image = UIImage(systemName: "magnifyingglass")
        items[1].image = UIImage(systemName: "person")
        items[2].image = UIImage(systemName: "heart")
        
        if let window = UIApplication.shared.windows.first {
            window.rootViewController = tabBarVC
            window.makeKeyAndVisible()
            UIView.transition(with: window, duration: 0.5, options: .transitionCrossDissolve, animations: nil, completion: nil)
        } else {
            print("Window not found")
        }
    }
    
    private func saveUserData() {
        let nickname = nicknameTextField.text ?? ""

        // 프로필 이미지 데이터를 저장
        let profileImageData = profileImageView.imageView.image?.pngData()
        
        let defaults = UserDefaults.standard
        defaults.set(nickname, forKey: "UserNickname")
        
        if let profileImageData = profileImageData {
            defaults.set(profileImageData, forKey: "UserProfileImage")
        }
        
        // 랜덤 이미지 이름을 가져와서 저장
        if let randomImageName = profileImageView.imageView.accessibilityIdentifier {
            defaults.set(randomImageName, forKey: "UserProfileImageName")
        }
        
        if defaults.string(forKey: "UserJoinDate") == nil {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            let joinDate = dateFormatter.string(from: Date())
            defaults.set(joinDate, forKey: "UserJoinDate")
        }
        
        defaults.synchronize() // 변경사항을 즉시 디스크에 기록
        
        // 디버깅 출력
        print("💡: \(nickname)")
        if let savedNickname = defaults.string(forKey: "UserNickname") {
            print("💡: \(savedNickname)")
        } else {
            print("미안해.")
        }
        
        printUserDefaults() // 저장 후 UserDefaults 출력
    }

    private func loadUserData() {
        let defaults = UserDefaults.standard
        if let nickname = defaults.string(forKey: "UserNickname") {
            nicknameTextField.text = nickname
            // 디버깅 출력
            print("닉네임이 등록되었어요: \(nickname)")
        } else {
            print("죄송해요.. 닉네임을 찾을 수 없네요")
        }

        // 프로필 이미지 데이터를 로드
        if let profileImageData = defaults.data(forKey: "UserProfileImage"), let profileImage = UIImage(data: profileImageData) {
            profileImageView.imageView.image = profileImage
        } else {
            let profileImages = ["profile_0", "profile_1", "profile_2", "profile_3", "profile_4", "profile_5", "profile_6", "profile_7", "profile_8", "profile_9", "profile_10", "profile_11"]
            let randomImageName = profileImages.randomElement() ?? "profile_0"
            profileImageView.imageView.image = UIImage(named: randomImageName)
            profileImageView.imageView.accessibilityIdentifier = randomImageName
            // 랜덤 이미지 이름을 UserDefaults에 저장
            UserDefaults.standard.set(randomImageName, forKey: "UserProfileImageName")
        }
        currentProfileImageName = defaults.string(forKey: "UserProfileImageName")
        printUserDefaults()  // UserDefaults 출력
    }

    private func printUserDefaults() {
        DispatchQueue.main.async {
            let defaults = UserDefaults.standard
            let nickname = defaults.string(forKey: "UserNickname") ?? "닉네임이 설정되지 않음"
            let profileImageName = defaults.string(forKey: "UserProfileImageName") ?? "프로필 이미지가 설정되지 않음"
            let isNicknameSet = defaults.bool(forKey: "isNicknameSet")
            let joinDate = defaults.string(forKey: "UserJoinDate") ?? "가입 날짜가 설정되지 않음"
            
            print("닉네임: \(nickname)")
            print("프로필 이미지 이름: \(profileImageName)")
            print("isNicknameSet: \(isNicknameSet)")
            print("가입 날짜: \(joinDate)")
        }
    }


    
    private func isValidNickname(nickname: String) -> Bool {
        let nicknameRegex = "^[가-힣a-zA-Z]{2,10}$"
        let predicate = NSPredicate(format: "SELF MATCHES %@", nicknameRegex)
        return predicate.evaluate(with: nickname)
    }
    
    private func evaluateNickname(nickname: String) -> String {
        if nickname.count < 2 || nickname.count >= 10 {
            return "2글자 이상 10글자 미만으로 설정해주세요"
        }
        if nickname.rangeOfCharacter(from: CharacterSet.decimalDigits) != nil {
            return "닉네임에 숫자는 포함 할 수 없어요"
        }
        if nickname.rangeOfCharacter(from: CharacterSet(charactersIn: "@#$%")) != nil {
            return "닉네임에 특수 문자를 포함할 수 없어요"
        }
        return "사용할 수 있는 닉네임이에요"
    }
}

extension ProfileSettingViewController: ProfileSelectionDelegate {
    func didSelectProfileImage(named: String) {
        DispatchQueue.main.async {
            self.profileImageView.imageView.image = UIImage(named: named)
            self.profileImageView.imageView.accessibilityIdentifier = named
        }
        //saveUserData() // 선택한 이미지를 즉시 저장
    }
}

protocol ProfileSelectionDelegate: AnyObject {
    func didSelectProfileImage(named: String)
}

extension ProfileSettingViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        DispatchQueue.main.async {
            let currentText = textField.text ?? ""
            let newText = (currentText as NSString).replacingCharacters(in: range, with: string)
            self.noteLabel.text = self.evaluateNickname(nickname: newText)
        }
        return true
    }
}
