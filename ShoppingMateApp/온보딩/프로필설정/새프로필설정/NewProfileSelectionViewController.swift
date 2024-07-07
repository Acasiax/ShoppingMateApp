//
//  NewProfileSelectionViewController.swift
//  ShoppingMateApp
//
//  Created by 이윤지 on 6/15/24.
//

import UIKit
import SnapKit

class NewProfileSelectionViewController: UIViewController {
    
    weak var delegate: ProfileSelectionDelegate?
    
    // 기본 프로필 이미지 목록
    private let profiles: [String] = ["profile_0", "profile_1", "profile_2", "profile_3", "profile_4", "profile_5", "profile_6", "profile_7", "profile_8", "profile_9", "profile_10", "profile_11"]
    
    private let profileImageView = ProfileImageView()
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 80, height: 80)
        layout.minimumInteritemSpacing = 20
        layout.minimumLineSpacing = 20
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .customWhite
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .customWhite
        collectionView.delegate = self
        collectionView.dataSource = self
        setupViews()
        setupConstraints()
        collectionView.register(ProfileCell.self, forCellWithReuseIdentifier: ProfileCell.reuseIdentifier)
        setupNavigationBar()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(profileImageTapped))
        profileImageView.isUserInteractionEnabled = true
        profileImageView.addGestureRecognizer(tapGesture)
        
        loadUserData()
    }
    
    private func setupNavigationBar() {
        navigationItem.title = "PROFILE SETTING"
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.customBlack, .font: UIFont.boldSystemFont(ofSize: 16)]
        navigationController?.navigationBar.tintColor = UIColor.customBlack
    }
    
    private func setupViews() {
        view.addSubview(profileImageView)
        view.addSubview(collectionView)
    }
    
    private func setupConstraints() {
        profileImageView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(40)
            make.centerX.equalToSuperview()
            make.width.height.equalTo(100)
        }
  
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(profileImageView.snp.bottom).offset(40)
            make.left.right.bottom.equalToSuperview()
        }
    }
    
    @objc private func profileImageTapped() {
      //없앰
    }
    
    private func loadUserData() {
        let defaults = UserDefaults.standard
        if let profileImageData = defaults.data(forKey: "UserProfileImage"), let profileImage = UIImage(data: profileImageData) {
            profileImageView.imageView.image = profileImage
        } else {
            let profileImages = profiles
            let randomImageName = profileImages.randomElement() ?? "profile_0"
            profileImageView.imageView.image = UIImage(named: randomImageName)
            profileImageView.imageView.accessibilityIdentifier = randomImageName
            UserDefaults.standard.set(randomImageName, forKey: "UserProfileImageName")
        }
    }
}

extension NewProfileSelectionViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return profiles.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProfileCell.reuseIdentifier, for: indexPath) as! ProfileCell
        let profileName = profiles[indexPath.item]
        let image = UIImage(named: profileName)
        image?.accessibilityIdentifier = profileName
        cell.imageView.image = image
        
        // 💡 현재 프로필 이미지와 같은지 비교하여 테두리 색상 및 불투명도 설정
        if let currentProfileImage = UserDefaults.standard.string(forKey: "UserProfileImageName"), currentProfileImage == profileName {
            cell.imageView.layer.borderColor = UIColor.customOrange.cgColor
            cell.imageView.layer.borderWidth = 3
            cell.imageView.alpha = 1.0
        } else {
            cell.imageView.layer.borderColor = UIColor.customGray4C4C.cgColor
            cell.imageView.layer.borderWidth = 1
            cell.imageView.alpha = 0.5
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedProfile = profiles[indexPath.item]
        delegate?.didSelectProfileImage(named: selectedProfile)
        UserDefaults.standard.setValue(selectedProfile, forKey: "UserProfileImageName")
        collectionView.reloadData()
        navigationController?.popViewController(animated: true)
    }
}
