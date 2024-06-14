//
//  LikeViewController.swift
//  ShoppingMateApp
//
//  Created by 이윤지 on 6/14/24.
//

import Foundation
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
        setupUI()
        fetchLikedItems()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchLikedItems()
        likeView.collectionView.reloadData()
    }

    private func setupUI() {
        configureNavigationBar()
        likeView.searchBar.delegate = self
        likeView.collectionView.delegate = self
        likeView.collectionView.dataSource = self
    }

    private func configureNavigationBar() {
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = .red
        appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        appearance.shadowColor = .clear
        navigationController?.setNavigationBarHidden(false, animated: false)
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.isTranslucent = false
        navigationItem.title = "좋아요 목록"
    }

    private func fetchLikedItems() {
        likedItems = likeRepository.fetchAll().filter("isLiked == true")
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
        }
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
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
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        isSearchActive = false
        likeView.collectionView.reloadData()
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
    }
}



class LikeView: BaseView {
    lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.placeholder = "검색"
        searchBar.layer.shadowColor = UIColor.clear.cgColor
        searchBar.showsCancelButton = true
        searchBar.barTintColor = .red
        searchBar.searchTextField.textColor = .white
        if let cancelButton = searchBar.value(forKey: "cancelButton") as? UIButton {
            cancelButton.setTitle("취소", for: .normal)
            cancelButton.titleLabel?.font = UIFont.systemFont(ofSize: 17)
            cancelButton.tintColor = .white
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
        view.backgroundColor = .purple
        return view
    }()

    override func configureView() {
        addSubview(searchBar)
        addSubview(collectionView)
    }

    override func setConstraints() {
        searchBar.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(50)
        }
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(searchBar.snp.bottom).offset(20)
            make.leading.trailing.bottom.equalToSuperview()
        }
    }
}
