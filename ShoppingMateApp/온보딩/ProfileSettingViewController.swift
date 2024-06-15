//
//  ProfileSettingViewController.swift
//  ShoppingMateApp
//
//  Created by 이윤지 on 6/15/24.
//

import UIKit

class ProfileSettingViewController: UIViewController {
    
    private let profileImageView = UIImageView()
    private let contentView = UIView()
    
    private let nicknameTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "닉네임을 입력해주세요 :)"
        textField.borderStyle = .roundedRect
        textField.textAlignment = .center
        return textField
    }()
    
    private let noteLabel: UILabel = {
        let label = UILabel()
        label.text = "닉네임에 @은 포함할 수 없어요."
        label.textColor = .orange
        label.font = UIFont.systemFont(ofSize: 14)
        label.textAlignment = .center
        return label
    }()
    
    private let completeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("완료", for: .normal)
        button.backgroundColor = .orange
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 8
        button.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
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
        printUserDefaults()
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
        navigationItem.title = navigationTitle
        navigationController?.navigationBar.titleTextAttributes = [.font: UIFont.boldSystemFont(ofSize: 18)]
        
        if showSaveButton {
            let saveButton = UIBarButtonItem(title: "저장", style: .plain, target: self, action: #selector(saveButtonTapped))
            saveButton.setTitleTextAttributes([.foregroundColor: UIColor.black, .font: UIFont.boldSystemFont(ofSize: 16)], for: .normal)
            navigationItem.rightBarButtonItem = saveButton
        }
        
    }
    
    private func setupViews() {
        view.addSubview(profileImageView)
        view.addSubview(contentView)
        
        contentView.addSubview(nicknameTextField)
        contentView.addSubview(noteLabel)
        contentView.addSubview(completeButton)
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
            make.left.equalToSuperview().offset(40)
            make.right.equalToSuperview().offset(-40)
        }
        
        completeButton.snp.makeConstraints { make in
            make.top.equalTo(noteLabel.snp.bottom).offset(30)
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
    
    private func saveUserData() {
           let nickname = nicknameTextField.text ?? ""
           let profileImageName = profileImageView.accessibilityIdentifier ?? ""
           let defaults = UserDefaults.standard
           
           defaults.set(nickname, forKey: "UserNickname")
           defaults.set(profileImageName, forKey: "UserProfileImage")
           defaults.set(true, forKey: "isNicknameSet")
           
           if defaults.string(forKey: "UserJoinDate") == nil {
               let dateFormatter = DateFormatter()
               dateFormatter.dateFormat = "yyyy-MM-dd"
               let joinDate = dateFormatter.string(from: Date())
               defaults.set(joinDate, forKey: "UserJoinDate")
           }
           
           printUserDefaults()
       }
    private func printUserDefaults() {
            let defaults = UserDefaults.standard
            let nickname = defaults.string(forKey: "UserNickname") ?? "닉네임이 설정되지 않음"
            let profileImageName = defaults.string(forKey: "UserProfileImage") ?? "프로필 이미지가 설정되지 않음"
            let isNicknameSet = defaults.bool(forKey: "isNicknameSet")
            let joinDate = defaults.string(forKey: "UserJoinDate") ?? "가입 날짜가 설정되지 않음"
            
            print("닉네임: \(nickname)")
            print("프로필 이미지 이름: \(profileImageName)")
            print("isNicknameSet: \(isNicknameSet)")
            print("가입 날짜: \(joinDate)")
        }
    
    private func loadUserData() {
           if let nickname = UserDefaults.standard.string(forKey: "UserNickname") {
               nicknameTextField.text = nickname
           }
           if let profileImageName = UserDefaults.standard.string(forKey: "UserProfileImage"),
              let profileImage = UIImage(named: profileImageName) {
               profileImageView.image = profileImage
               profileImageView.accessibilityIdentifier = profileImageName
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
        
        private func navigateToNextScreen() {
            let nextViewController = UIViewController() // SettingViewController로 교체 필요
            nextViewController.view.backgroundColor = .white
            self.navigationController?.pushViewController(nextViewController, animated: true)
        }
}

extension ProfileSettingViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentText = textField.text ?? ""
        let newText = (currentText as NSString).replacingCharacters(in: range, with: string)
        noteLabel.text = evaluateNickname(nickname: newText)
        return true
    }
}

protocol ProfileSelectionDelegate: AnyObject {
    func didSelectProfileImage(named: String)
}

class ProfileCell: UICollectionViewCell {
    
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        //imageView.alpha = 0.5 // 이미지 반투명 설정
        imageView.layer.cornerRadius = 40
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 1
        imageView.layer.borderColor = UIColor.gray.cgColor
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
