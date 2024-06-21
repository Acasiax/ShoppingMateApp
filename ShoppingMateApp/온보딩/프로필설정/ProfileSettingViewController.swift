//
//  ProfileSettingViewController.swift
//  ShoppingMateApp
//
//  Created by 이윤지 on 6/15/24.
//
import UIKit
import SnapKit

class ProfileSettingViewController: UIViewController {
    
    private let profileImageView = ProfileImageView()
    private let contentView = UIView()
    private var currentProfileImageName: String?
    
    private let nicknameTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "닉네임을 입력해주세요 :)"
        textField.textAlignment = .left
        textField.autocorrectionType = .no
        textField.spellCheckingType = .no
        return textField
    }()
    
    private let bottomLineView: UIView = {
        let view = UIView()
        view.backgroundColor = .customLightGrayCDCD
        return view
    }()
    
    private let noteLabel: UILabel = {
        let label = UILabel()
        label.text = "닉네임에 @ 는 포함할 수 없어요."
        label.textColor = .customOrange
        label.font = UIFont.systemFont(ofSize: 14)
        label.textAlignment = .center
        return label
    }()
    
    // "완료","로그인 없이 둘러볼게요 버튼" UIButton에 applyCustomStyle 확장 메서드 추가🔥
    private let completeButton: UIButton = {
        let button = UIButton(type: .system)
        button.applyCustomStyle(title: "완료", fontSize: 15, cornerRadius: 23, backgroundColor: .customOrange, titleColor: .customWhite)
        button.addTarget(self, action: #selector(okButtonTapped), for: .touchUpInside)
        return button
    }()

    private let passButton: UIButton = {
        let button = UIButton(type: .system)
        button.applyCustomStyle(title: "로그인 없이 둘러볼게요", fontSize: 15, cornerRadius: 23, backgroundColor: .customOrange, titleColor: .customWhite)
        button.addTarget(self, action: #selector(passButtonTapped), for: .touchUpInside)
        return button
    }()
    
    
    private var navigationTitle: String
    private var showSaveButton: Bool
    
    private var showCompleteButton: Bool
    private var showPassButton: Bool
    
    init(navigationTitle: String, showSaveButton: Bool, showCompleteButton: Bool, showPassButton: Bool) {
        self.navigationTitle = navigationTitle
        self.showSaveButton = showSaveButton
        self.showCompleteButton = showCompleteButton
        self.showPassButton = showPassButton
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        self.navigationTitle = ""
        self.showSaveButton = false
        self.showCompleteButton = true
        self.showPassButton = true
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .customWhite
        setupNavigationBar()
        setupViews()
        setupConstraints()
        loadUserData()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(profileImageTapped))
        profileImageView.isUserInteractionEnabled = true
        profileImageView.addGestureRecognizer(tapGesture)
        
        nicknameTextField.delegate = self
    }
    
    private func setupNavigationBar() {
        navigationItem.title = showSaveButton ? "EDIT PROFILE" : "PROFILE SETTING"
        navigationController?.navigationBar.titleTextAttributes = [.font: UIFont.boldSystemFont(ofSize: 16)]
        
        if showSaveButton {
            let saveButton = UIBarButtonItem(title: "저장", style: .plain, target: self, action: #selector(saveButtonTapped))
            saveButton.setTitleTextAttributes([.foregroundColor: UIColor.customBlack, .font: UIFont.systemFont(ofSize: 16, weight: .black)], for: .normal)
            navigationItem.rightBarButtonItem = saveButton
        }
    }
    
    private func setupViews() {
        view.addSubview(profileImageView)
        view.addSubview(contentView)
        
        contentView.addSubview(nicknameTextField)
        contentView.addSubview(bottomLineView)
        contentView.addSubview(noteLabel)
        if showCompleteButton {
            contentView.addSubview(completeButton)
        }
        if showPassButton {
            contentView.addSubview(passButton)
        }
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
            make.top.equalTo(contentView.snp.top).offset(35)
            make.left.equalToSuperview().offset(40)
            make.right.equalToSuperview().offset(-40)
        }
        
        bottomLineView.snp.makeConstraints { make in
            make.top.equalTo(nicknameTextField.snp.bottom).offset(10)
            make.left.equalToSuperview().offset(40)
            make.right.equalToSuperview().offset(-40)
            make.height.equalTo(1)
        }
        noteLabel.snp.makeConstraints { make in
            make.top.equalTo(bottomLineView.snp.bottom).offset(10)
            make.left.equalToSuperview().offset(45)
        }
        
        if showCompleteButton {
            completeButton.snp.makeConstraints { make in
                make.top.equalTo(noteLabel.snp.bottom).offset(30)
                make.left.equalToSuperview().offset(40)
                make.right.equalToSuperview().offset(-40)
                make.height.equalTo(50)
            }
        }
        
        if showPassButton {
            passButton.snp.makeConstraints { make in
                make.top.equalTo(completeButton.snp.bottom).offset(10)
                make.left.equalToSuperview().offset(40)
                make.right.equalToSuperview().offset(-40)
                make.height.equalTo(50)
            }
        }
    }
    
    @objc private func profileImageTapped() {
        let newViewController = NewProfileSelectionViewController()
          newViewController.delegate = self
        let backButton = UIBarButtonItem()
          backButton.title = ""
          navigationItem.backBarButtonItem = backButton
          navigationController?.pushViewController(newViewController, animated: true)
    }

    
    //🔥 완료 버튼 눌렀을 때!!
    @objc private func okButtonTapped() {
        let nickname = nicknameTextField.text ?? ""
        let validationMessage = evaluateNickname(nickname: nickname)
        
        if validationMessage == "사용할 수 있는 닉네임이에요" {
            saveUserData { success in
                if success {
                    self.navigateToNextScreen()
                } else {
                    print("데이터 저장에 실패했어요")
                }
            }
        } else {
            let alert = UIAlertController(title: "경고", message: validationMessage, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "확인", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
        }
    }
    
    
    
    
    
    
    //이거는 저장 버튼임 프로필 수정할 때
    @objc private func saveButtonTapped() {
        let nickname = nicknameTextField.text ?? ""
        let validationMessage = evaluateNickname(nickname: nickname)
        
        if validationMessage == "사용할 수 있는 닉네임이에요" {
            saveUserData { success in
                if success {
                    self.navigateToNextScreen()
                } else {
                    print("데이터 저장에 실패했어요")
                }
            }
        } else {
            let alert = UIAlertController(title: "경고", message: validationMessage, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "확인", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
        }
    }

    
//    @objc private func saveButtonTapped() {
//        
//        let nickname = nicknameTextField.text ?? ""
//        let validationMessage = evaluateNickname(nickname: nickname)
//        if validationMessage == "사용할 수 있는 닉네임이에요" {
//            saveUserData()
//            navigateToNextScreen()
//        } else {
//            let alert = UIAlertController(title: "경고", message: validationMessage, preferredStyle: .alert)
//            alert.addAction(UIAlertAction(title: "확인", style: .default, handler: nil))
//            present(alert, animated: true, completion: nil)
//        }
//    }
    
    //둘러볼게요 버튼
    @objc private func passButtonTapped() {
        navigateToNextScreen() //⚠️
        
         saveUserData { success in
             if success {
                 self.navigateToNextScreen()
             } else {
                 print("데이터 저장에 실패했어요")
             }
         }
     }
     
    
//    private func navigateToNextScreen() {
//        let tabBarVC = UITabBarController()
//        
//        let homeVC = HomeViewController()
//        let settingsVC = SettingViewController(navigationTitle: "세팅뷰우", showSaveButton: false)
//      //  let likeVC = LikeViewController()
//        
//        let searchNavVC = UINavigationController(rootViewController: homeVC)
//        searchNavVC.tabBarItem = UITabBarItem(title: "검색", image: UIImage(systemName: "magnifyingglass"), tag: 0)
//        
//        let settingsNavVC = UINavigationController(rootViewController: settingsVC)
//        settingsNavVC.tabBarItem = UITabBarItem(title: "설정", image: UIImage(systemName: "gearshape"), tag: 1)
//        
////        let likeNavVC = UINavigationController(rootViewController: likeVC)
////        likeNavVC.tabBarItem = UITabBarItem(title: "좋아요", image: UIImage(systemName: "heart"), tag: 2)
//        
//        tabBarVC.setViewControllers([searchNavVC, settingsNavVC], animated: false)
//        tabBarVC.tabBar.backgroundColor = UIColor(red: 0.97, green: 0.98, blue: 0.98, alpha: 1.00)
//        tabBarVC.tabBar.tintColor = .customWhite
//        tabBarVC.tabBar.unselectedItemTintColor = .customGray4C4C
//        
//        tabBarVC.tabBar.tintColor = .customOrange
//        tabBarVC.tabBar.unselectedItemTintColor = .customGray4C4C
//        
//        guard let items = tabBarVC.tabBar.items else { return }
//        items[0].image = UIImage(systemName: "magnifyingglass")
//        items[1].image = UIImage(systemName: "person")
//        items[2].image = UIImage(systemName: "heart")
//        
//        if let window = UIApplication.shared.windows.first {
//            window.rootViewController = tabBarVC
//            window.makeKeyAndVisible()
//            UIView.transition(with: window, duration: 0.5, options: .transitionCrossDissolve, animations: nil, completion: nil)
//        } else {
//            print("Window를 못 찾았어요")
//        }
//    }
    
    private func navigateToNextScreen() {
        let tabBarVC = UITabBarController()
        
        let homeVC = HomeViewController()
        let settingsVC = SettingViewController(navigationTitle: "세팅뷰우", showSaveButton: false)
        let likeVC = ThreeCollectionViewController()
        
        let searchNavVC = UINavigationController(rootViewController: homeVC)
        searchNavVC.tabBarItem = UITabBarItem(title: "검색", image: UIImage(systemName: "magnifyingglass"), tag: 0)
        
        let settingsNavVC = UINavigationController(rootViewController: settingsVC)
        settingsNavVC.tabBarItem = UITabBarItem(title: "설정", image: UIImage(systemName: "gearshape"), tag: 1)
        
        let likeNavVC = UINavigationController(rootViewController: likeVC)
        likeNavVC.tabBarItem = UITabBarItem(title: "좋아요", image: UIImage(systemName: "heart"), tag: 2)
        
        // 여기서 세 개의 네비게이션 컨트롤러를 추가합니다.
        tabBarVC.setViewControllers([searchNavVC, settingsNavVC, likeNavVC], animated: false)
        tabBarVC.tabBar.backgroundColor = UIColor(red: 0.97, green: 0.98, blue: 0.98, alpha: 1.00)
        tabBarVC.tabBar.tintColor = .customOrange
        tabBarVC.tabBar.unselectedItemTintColor = .customGray4C4C
        
        if let window = UIApplication.shared.windows.first {
            window.rootViewController = tabBarVC
            window.makeKeyAndVisible()
            UIView.transition(with: window, duration: 0.5, options: .transitionCrossDissolve, animations: nil, completion: nil)
        } else {
            print("Window를 못 찾았어요")
        }
    }

    
    private func saveUserData(completion: @escaping (Bool) -> Void) {
        let nickname = nicknameTextField.text ?? ""

        // 닉네임이 빈 문자열인지 확인
        if nickname.isEmpty {
            print("⚠️⚠️ 닉네임이 빈 문자열이어서 저장하지 않습니다.")
            completion(false)
            return
        }

        let profileImageData = profileImageView.imageView.image?.pngData()
        let defaults = UserDefaults.standard

        // 데이터 저장
        defaults.set(nickname, forKey: "UserNickname")

        if let profileImageData = profileImageData {
            defaults.set(profileImageData, forKey: "UserProfileImage")
        }

        if let randomImageName = profileImageView.imageView.accessibilityIdentifier {
            defaults.set(randomImageName, forKey: "UserProfileImageName")
        }

        if defaults.string(forKey: "UserJoinDate") == nil {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            let joinDate = dateFormatter.string(from: Date())
            defaults.set(joinDate, forKey: "UserJoinDate")
        }

        // 닉네임 설정 여부 저장
        defaults.set(true, forKey: "isNicknameSet")

        // 저장된 값 확인
        DispatchQueue.main.async {
            if let savedNickname = defaults.string(forKey: "UserNickname") {
                print("💡: \(savedNickname)")
                completion(true)
            } else {
                print("⚠️⚠️ 닉네임을 유저디폴트에 저장하지 못했습니다!")
                completion(false)
            }
            self.printUserDefaults() // 현재 상태 출력
        }
    }


    private func printUserDefaults() {
        DispatchQueue.main.async {
            let defaults = UserDefaults.standard
            
            if let nickname = defaults.string(forKey: "UserNickname") {
                print("닉네임: \(nickname)")
            } else {
                print("닉네임: 없음")
            }

            if let profileImageData = defaults.data(forKey: "UserProfileImage") {
                print("프로필 이미지 데이터: \(profileImageData.count) 바이트")
            } else {
                print("프로필 이미지 데이터: 없음")
            }

            if let profileImageName = defaults.string(forKey: "UserProfileImageName") {
                print("프로필 이미지 이름: \(profileImageName)")
            } else {
                print("프로필 이미지 이름: 없음")
            }

            if let joinDate = defaults.string(forKey: "UserJoinDate") {
                print("가입 날짜: \(joinDate)")
            } else {
                print("가입 날짜: 없음")
            }

            let isNicknameSet = defaults.bool(forKey: "isNicknameSet")
            print("닉네임 설정 여부: \(isNicknameSet)")
        }
    }

    
    //🕵🏻‍♂️🔍
    private func loadUserData() {
        let defaults = UserDefaults.standard
        if let nickname = defaults.string(forKey: "UserNickname") {
            nicknameTextField.text = nickname
            print("유저디폴트에 닉네임 기록이 있네요: \(nickname)")
        } else {
            print("유저디폴트에 닉네임 기록이 없습니다. 처음 실행하나봐요")
        }
        
        if let profileImageData = defaults.data(forKey: "UserProfileImage"), let profileImage = UIImage(data: profileImageData) {
            profileImageView.imageView.image = profileImage
        } else {
            let profileImages = ["profile_0", "profile_1", "profile_2", "profile_3", "profile_4", "profile_5", "profile_6", "profile_7", "profile_8", "profile_9", "profile_10", "profile_11"]
            let randomImageName = profileImages.randomElement() ?? "profile_0"
            profileImageView.imageView.image = UIImage(named: randomImageName)
            profileImageView.imageView.accessibilityIdentifier = randomImageName
            UserDefaults.standard.set(randomImageName, forKey: "UserProfileImageName")
        }
        currentProfileImageName = defaults.string(forKey: "UserProfileImageName")
        printUserDefaults()
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
            return "닉네임에 @,#,$,% 는 포함할 수 없어요"
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
        saveUserData { success in
            if success {
                print("Profile image name updated successfully")
            }
        }
    }
}

protocol ProfileSelectionDelegate: AnyObject {
    func didSelectProfileImage(named: String)
}

extension ProfileSettingViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
            if let currentText = textField.text as NSString? {
                let newText = currentText.replacingCharacters(in: range, with: string)
                let validationMessage = self.evaluateNickname(nickname: newText)
                self.noteLabel.text = validationMessage
                
                if validationMessage == "사용할 수 있는 닉네임이에요" {
                    self.noteLabel.textColor = .customBlack
                } else {
                    self.noteLabel.textColor = .customOrange
                }

                if newText.isEmpty {
                    self.bottomLineView.backgroundColor = .customLightGrayCDCD
                    self.bottomLineView.snp.updateConstraints { make in
                        make.height.equalTo(1)
                    }
                } else {
                    self.bottomLineView.backgroundColor = .customGray8282
                    self.bottomLineView.snp.updateConstraints { make in
                        make.height.equalTo(2)
                    }
                }
            }
            return true
        }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
            if let nickname = textField.text {
                let validationMessage = evaluateNickname(nickname: nickname)
                noteLabel.text = validationMessage
                if validationMessage == "사용할 수 있는 닉네임이에요" {
                    noteLabel.textColor = .customOrange
                } else {
                    noteLabel.textColor = .red
                }
            }
        }
    
    
}
