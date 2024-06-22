//
//  ThreetapViewController.swift
//  ShoppingMateApp
//
//  Created by 이윤지 on 6/21/24.
//
import UIKit
import SnapKit
import Kingfisher

class ThreeCollectionViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    private var collectionView: UICollectionView!
    private var items: [LikedItem] = [] // 예제 데이터를 위한 배열
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        loadLikedItems() // 저장된 좋아요 항목을 로드하는 메소드 호출
        setupNotificationCenter() // NotificationCenter 설정
    }
    
    private func setupNotificationCenter() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleLikeStatusChanged), name: NSNotification.Name("LikeStatusChanged"), object: nil)
    }
    @objc private func handleLikeStatusChanged() {
        loadLikedItems()
    }
    private func setupCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .white
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
        collectionView.reloadData() // 데이터를 로드한 후 컬렉션뷰를 리로드합니다.
    }
    
    // UICollectionViewDataSource Methods
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
        return CGSize(width: collectionView.frame.width - 80, height: 250) // 몇개 나올지!
    }
}

class ThreeCollectionCell: UICollectionViewCell {
    private let imageView = UIImageView()
    private let mallNameLabel = UILabel()
    private let titleLabel = UILabel()
    private let priceLabel = UILabel()
    private let likeButton = UIButton(type: .system)
    
    private var item: LikedItem?
    private var isLiked: Bool = false {
        didSet {
            updateLikeButtonImage()
        }
    }
    
    private let likedImageName = "like_selected"
    private let unlikedImageName = "like_unselected"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configureView() {
        setupUI()
        setConstraints()
        setupActions()
    }
    
    private func setConstraints() {
        imageView.snp.makeConstraints { make in
            make.horizontalEdges.top.equalToSuperview()
            make.height.equalTo(170)
        }
        [mallNameLabel, titleLabel, priceLabel].forEach { label in
            label.snp.makeConstraints { make in
                make.leading.trailing.equalToSuperview().inset(7)
            }
        }
        mallNameLabel.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(3)
            make.height.equalTo(20)
        }
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(mallNameLabel.snp.bottom).offset(3)
        }
        priceLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(3)
            make.height.equalTo(20)
        }
        likeButton.snp.makeConstraints { make in
            make.bottom.trailing.equalTo(imageView).inset(8)
            make.size.equalTo(36)
        }
    }
    
    func configure(with item: LikedItem) {
        self.item = item
        updateUI()
        loadLikeStatus()
    }
    
    private func setupUI() {
        imageView.setupImageView()
        [mallNameLabel, titleLabel, priceLabel].forEach { label in
            contentView.addSubview(label)
        }
        likeButton.setupLikeButton(unlikedImageName: unlikedImageName)
        contentView.addSubview(imageView)
        contentView.addSubview(likeButton)
    }
    
    private func setupActions() {
        likeButton.addTarget(self, action: #selector(toggleLike), for: .touchUpInside)
    }
    
    @objc private func toggleLike() {
        isLiked.toggle()
        if let item = item {
            saveLikedStatus(for: item)
            NotificationCenter.default.post(name: NSNotification.Name("LikeStatusChanged"), object: nil)
        }
    }
    
    private func updateUI() {
        guard let item = item else { return }
        
        mallNameLabel.text = "Sample Mall"
        titleLabel.text = item.title.cleanedTitle()
        priceLabel.text = item.price
        
        if let imageURL = URL(string: item.imageName) {
            imageView.kf.setImage(with: imageURL)
        }
    }
    
    private func loadLikeStatus() {
        guard let item = item else { return }
        let likedItems = FileManagerHelper.shared.loadLikedItems()
        isLiked = likedItems.contains { $0.title == item.title }
    }
    
    private func updateLikeButtonImage() {
        likeButton.setImage(UIImage(named: isLiked ? likedImageName : unlikedImageName)?.withRenderingMode(.alwaysOriginal), for: .normal)
        likeButton.backgroundColor = isLiked ? .white : .lightGray.withAlphaComponent(0.5)
    }
    
    private func saveLikedStatus(for item: LikedItem) {
        var likedItems = FileManagerHelper.shared.loadLikedItems()
        
        if isLiked {
            likedItems.append(item)
        } else {
            likedItems.removeAll { $0.title == item.title }
        }
        
        FileManagerHelper.shared.saveLikedItems(likedItems)
        FileManagerHelper.shared.printLikedItemsCount()
    }
}

private extension UIImageView {
    func setupImageView() {
        contentMode = .scaleToFill
        layer.cornerRadius = 15
        clipsToBounds = true
    }
}

private extension UIButton {
    func setupLikeButton(unlikedImageName: String) {
        if let unlikedImage = UIImage(named: unlikedImageName)?.withRenderingMode(.alwaysOriginal) {
            setImage(unlikedImage, for: .normal)
        }
        backgroundColor = .lightGray.withAlphaComponent(0.5)
        tintColor = .white
        layer.cornerRadius = 18
        clipsToBounds = true
    }
}

private extension String {
    func cleanedTitle() -> String {
        return replacingOccurrences(of: "<b>", with: "").replacingOccurrences(of: "</b>", with: "")
    }
}
