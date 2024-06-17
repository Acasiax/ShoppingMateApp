//
//  NewProfileSelectionViewController.swift
//  ShoppingMateApp
//
//  Created by 이윤지 on 6/15/24.
//

import UIKit

class NewProfileSelectionViewController: UIViewController {
    
    weak var delegate: ProfileSelectionDelegate?
    private let profiles: [String] = ["profile_0", "profile_1", "profile_2", "profile_3", "profile_4", "profile_5", "profile_6", "profile_7", "profile_8", "profile_9", "profile_10", "profile_11"]
    
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
        collectionView.register(ProfileCell.self, forCellWithReuseIdentifier: ProfileCell.id)
    }
    
    private func setupViews() {
        view.addSubview(collectionView)
    }
    
    private func setupConstraints() {
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}

extension NewProfileSelectionViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return profiles.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProfileCell.id, for: indexPath) as! ProfileCell
        let profileName = profiles[indexPath.item]
        let image = UIImage(named: profileName)
        image?.accessibilityIdentifier = profileName
        cell.imageView.image = image
        
        // 💡 현재 프로필 이미지와 같은지 비교하여 테두리 색상 및 불투명도 설정
        if let currentProfileImage = UserDefaults.standard.string(forKey: "UserProfileImageName"), currentProfileImage == profileName {
            cell.imageView.layer.borderColor = UIColor.customOrange.cgColorValue
            cell.imageView.layer.borderWidth = 3
            cell.imageView.alpha = 1.0
        } else {
            cell.imageView.layer.borderColor = UIColor.gray.cgColor
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
        self.view.removeFromSuperview()
        self.removeFromParent()
    }
}
