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
        setupNavigationBar()
        setupViews()
        setupConstraints()
        
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
    
    
    
    @objc private func saveButtonTapped() {
        // 저장 버튼 기능
    }
}
