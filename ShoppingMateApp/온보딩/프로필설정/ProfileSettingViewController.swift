//
//  ProfileSettingViewController.swift
//  ShoppingMateApp
//
//  Created by 이윤지 on 6/15/24.
//

import UIKit
import SnapKit

class ProfileSettingViewController: UIViewController {
    
     let profileImageView = ProfileImageView()
     let contentView = UIView()
     var currentProfileImageName: String?
     var navigationTitle: String
     var showSaveButton: Bool
     var showCompleteButton: Bool
     var showPassButton: Bool
    
    let nicknameTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "닉네임을 입력해주세요 :)"
        textField.textAlignment = .left
        textField.autocorrectionType = .no
        textField.spellCheckingType = .no
        return textField
    }()
    
     let bottomLineView: UIView = {
        let view = UIView()
        view.backgroundColor = .customLightGrayCDCD
        return view
    }()
    
     let noteLabel: UILabel = {
        let label = UILabel()
        label.text = "닉네임에 @ 는 포함할 수 없어요."
        label.textColor = .customOrange
        label.font = UIFont.systemFont(ofSize: 14)
        label.textAlignment = .center
        return label
    }()
    
    // "완료","로그인 없이 둘러볼게요 버튼" UIButton에 applyCustomStyle 확장 메서드 추가🔥
     let completeButton: UIButton = {
        let button = UIButton(type: .system)
        button.applyCustomStyle(title: "완료", fontSize: 15, cornerRadius: 23, backgroundColor: .customOrange, titleColor: .customWhite)
        button.addTarget(self, action: #selector(okButtonTapped), for: .touchUpInside)
        return button
    }()

     let passButton: UIButton = {
        let button = UIButton(type: .system)
        button.applyCustomStyle(title: "로그인 없이 둘러볼게요", fontSize: 15, cornerRadius: 23, backgroundColor: .customOrange, titleColor: .customWhite)
        button.addTarget(self, action: #selector(passButtonTapped), for: .touchUpInside)
        return button
    }()
    
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
    
     func setupNavigationBar() {
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
        handleNicknameValidationAndSave()
    }
    
    //이거는 저장 버튼임 프로필 수정할 때
    @objc private func saveButtonTapped() {
        handleNicknameValidationAndSave()
    }

    //둘러볼게요 버튼
    @objc private func passButtonTapped() {
        navigateToNextScreen()
//        navigateToNextScreen() //⚠️
//        
         saveUserData { success in
             if success {
                 self.navigateToNextScreen()
             } else {
                 print("데이터 저장에 실패했어요")
             }
         }
     }
     

       func navigateToNextScreen() {
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
}

extension ProfileSettingViewController: ProfileSelectionDelegate {
    func didSelectProfileImage(named: String) {
        DispatchQueue.main.async {
            self.profileImageView.imageView.image = UIImage(named: named)
            self.profileImageView.imageView.accessibilityIdentifier = named
        }
        saveUserData { success in
            if success {
                print("프로필 이미지 이름이 성공적으로 업데이트 되었어요")
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
