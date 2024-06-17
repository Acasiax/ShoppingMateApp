//
//  LikeViewController.swift
//  ShoppingMateApp
//
//  Created by 이윤지 on 6/14/24.
//

import UIKit
import RealmSwift

class LikeViewController: ReuseBaseViewController {
    let likeView = LikeView()
    var networkManager = NetworkManager.shared
    var likedItems: Results<LikeTable>!
    var filteredLikedItems: Results<LikeTable>!
    let realmDatabase = try! Realm()
    let likeRepository = LikeTableRepository()
    var isSearchActive = false

    override func loadView() {
        self.view = likeView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupUI()
        fetchLikedItems()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchLikedItems()
        likeView.collectionView.reloadData()
        updateEmptyImageViewVisibility()
    }

    private func setupUI() {
        configureNavigationBar()
        likeView.searchBar.delegate = self
        likeView.collectionView.delegate = self
        likeView.collectionView.dataSource = self
    }

    private func configureNavigationBar() {
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = .white
        appearance.titleTextAttributes = [.foregroundColor: UIColor.black]
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.black]
        //구분선
        appearance.shadowColor = .clear
        navigationController?.setNavigationBarHidden(false, animated: false)
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        navigationController?.navigationBar.tintColor = .black
        navigationController?.navigationBar.isTranslucent = false
        navigationItem.title = "나의 장바구니 목록"
    }

    private func fetchLikedItems() {
        likedItems = likeRepository.fetchAll().filter("isLiked == true")
        updateEmptyImageViewVisibility()
    }
    
    private func updateEmptyImageViewVisibility() {
           let isEmpty = likedItems.isEmpty
           likeView.emptyImageView.isHidden = !isEmpty
           likeView.emptyLabel.isHidden = !isEmpty
       }
    
}

// MARK: - UICollectionViewDelegate, UICollectionViewDataSource
extension LikeViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return isSearchActive ? filteredLikedItems.count : likedItems.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "LikeCollectionViewCell", for: indexPath) as! LikeCollectionViewCell
        let item = isSearchActive ? filteredLikedItems[indexPath.row] : likedItems[indexPath.row]
        cell.configure(with: item)
        cell.onItemDeleted = {
            self.fetchLikedItems()
            collectionView.reloadData()
            self.updateEmptyImageViewVisibility()
        }
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("이거클릭")
        let likeItem = likedItems[indexPath.row]
        let webVC = WebViewController()
        webVC.productID = likeItem.productID
        webVC.likedProductItem = likeItem
        webVC.webViewTitle = likeItem.title.replacingOccurrences(of: "<b>", with: "").replacingOccurrences(of: "</b>", with: "")
        navigationController?.pushViewController(webVC, animated: true)
    }
}

// MARK: - UISearchBarDelegate
extension LikeViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let text = likeView.searchBar.text, !text.isEmpty else { return }
        filteredLikedItems = likedItems.filter("title CONTAINS[c] %@", text)
        isSearchActive = true
        likeView.collectionView.reloadData()
        updateEmptyImageViewVisibility()
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        isSearchActive = false
        likeView.collectionView.reloadData()
        updateEmptyImageViewVisibility()
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            isSearchActive = false
            likeView.collectionView.reloadData()
        } else {
            filteredLikedItems = likedItems.filter("title CONTAINS[c] %@", searchText)
            isSearchActive = true
            likeView.collectionView.reloadData()
        }
        updateEmptyImageViewVisibility()
    }
}



class LikeView: BaseView {
    
    let emptyImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "empty")
        imageView.contentMode = .scaleAspectFill
        imageView.isHidden = true
        return imageView
    }()
    
    let emptyLabel: UILabel = {
        let label = UILabel()
        label.text = "좋아요한 상품이 없어요"
        label.textColor = .black
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 17, weight: .bold)
        label.isHidden = true
        return label
    }()
    
    lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.placeholder = "좋아요한 상품들 중 검색해보세요"
        searchBar.layer.shadowColor = UIColor.clear.cgColor
        searchBar.searchBarStyle = .minimal
        searchBar.showsCancelButton = true
       // searchBar.barTintColor = .red
        searchBar.searchTextField.textColor = .black
        if let cancelButton = searchBar.value(forKey: "cancelButton") as? UIButton {
            cancelButton.setTitle("취소", for: .normal)
            cancelButton.titleLabel?.font = UIFont.systemFont(ofSize: 17)
            cancelButton.tintColor = .orange
        }
        return searchBar
    }()

    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 20
        layout.minimumInteritemSpacing = 5
        layout.itemSize = CGSize(width: (UIScreen.main.bounds.width - 30) / 2, height: 250)
        
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.register(LikeCollectionViewCell.self, forCellWithReuseIdentifier: "LikeCollectionViewCell")
        view.backgroundColor = .white
        return view
    }()

    override func configureView() {
        addSubview(searchBar)
        addSubview(collectionView)
        addSubview(emptyImageView)
        addSubview(emptyLabel)
    }

    override func setConstraints() {
        searchBar.snp.makeConstraints { make in
                make.top.equalToSuperview().offset(0)
                make.horizontalEdges.equalToSuperview()
                make.height.equalTo(50)
            }
            collectionView.snp.makeConstraints { make in
                make.top.equalTo(searchBar.snp.bottom).offset(20)
                make.leading.trailing.bottom.equalToSuperview()
            }
            emptyImageView.snp.makeConstraints { make in
                make.center.equalToSuperview()
                make.width.height.equalTo(230)
            }
            
            emptyLabel.snp.makeConstraints { make in
                make.top.equalTo(emptyImageView.snp.bottom).offset(8)
                make.centerX.equalToSuperview()
        }
    }
}
