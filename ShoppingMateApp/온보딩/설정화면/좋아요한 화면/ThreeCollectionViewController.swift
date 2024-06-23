//
//  ThreetapViewController.swift
//  ShoppingMateApp
//
//  Created by 이윤지 on 6/21/24.
//
import UIKit
import SnapKit

class ThreeCollectionViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    private var collectionView: UICollectionView!
    private var items: [LikedItem] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollectionView()
        loadLikedItems() // 저장된 좋아요 항목을 로드하는 메소드 호출
        configureNotificationCenter() // NotificationCenter 설정
    }
    
    
    private func configureNotificationCenter() {
        NotificationCenter.default.addObserver(self, selector: #selector(reloadLikedItems), name: NSNotification.Name("LikeStatusChanged"), object: nil)
    }
    @objc private func reloadLikedItems() {
        loadLikedItems()
    }
    private func configureCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = UIColor(red: 1.00, green: 0.97, blue: 0.82, alpha: 1.00)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(ThreeCollectionCell.self, forCellWithReuseIdentifier: "CustomCollectionViewCell")
        
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    // 저장된 좋아요 항목을 로드하는 메소드
    private func loadLikedItems() {
        items = FileManagerHelper.shared.loadLikedItems()
        collectionView.reloadData() 
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CustomCollectionViewCell", for: indexPath) as? ThreeCollectionCell else {
            return UICollectionViewCell()
        }
        let item = items[indexPath.row]
        cell.configure(with: item)
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width - 60, height: 250) // 몇개 나올지!
    }
}

