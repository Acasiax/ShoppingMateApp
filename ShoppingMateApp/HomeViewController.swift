//
//  HomeViewController.swift
//  ShoppingMateApp
//
//  Created by 이윤지 on 6/14/24.
//

import Foundation
import UIKit
import SnapKit
import RealmSwift

class HomeViewController: ReuseBaseViewController {
    let homeView = MainSearchView()
    var shopManager = NetworkManager.shared
    var productItems: [Item] = []
    var favoriteItems: Results<LikeTable>!
    let realmDatabase = try! Realm()
    let likeTableRepository = LikeTableRepository()
    var isDataEnd = false
    var pageStartNumber = 1
    var isDataLoading = false
    
    //검색 결과가 없을 때 표시할 이미지 뷰
     let emptyImageView: UIImageView = {
         let imageView = UIImageView()
         imageView.image = UIImage(named: "empty")
         imageView.contentMode = .scaleAspectFill
         imageView.isHidden = true // 기본적으로 숨김
         return imageView
     }()
    
    let emptyLabel: UILabel = {
            let label = UILabel()
            label.text = "최근 검색어가 없어요"
            label.textColor = .systemPink
            label.textAlignment = .center
            label.isHidden = true // 기본적으로 숨김
            return label
        }()
    
    
    override func loadView() {
        self.view = homeView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
                view.addGestureRecognizer(tapGesture)
        tapGesture.cancelsTouchesInView = false // 🌟
       
        setupUI()
        setupEmptyImageView()
        print(realmDatabase.configuration.fileURL)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        homeView.collectionView.reloadData()
        updateEmptyImageViewVisibility()
        
    }
    @objc func dismissKeyboard() {
           view.endEditing(true)
       }
    private func setupUI() {
        setupNavigationUI()
        homeView.searchBar.delegate = self
        homeView.collectionView.delegate = self
        homeView.collectionView.dataSource = self
        homeView.collectionView.prefetchDataSource = self

        homeView.accuracyButton.addTarget(self, action: #selector(toggleButtonColor), for: .touchUpInside)
        homeView.dateButton.addTarget(self, action: #selector(toggleButtonColor), for: .touchUpInside)
        homeView.upPriceButton.addTarget(self, action: #selector(toggleButtonColor), for: .touchUpInside)
        homeView.downPriceButton.addTarget(self, action: #selector(toggleButtonColor), for: .touchUpInside)
        
        homeView.accuracyButton.addTarget(self, action: #selector(changeSort), for: .touchUpInside)
        homeView.dateButton.addTarget(self, action: #selector(changeSort), for: .touchUpInside)
        homeView.upPriceButton.addTarget(self, action: #selector(changeSort), for: .touchUpInside)
        homeView.downPriceButton.addTarget(self, action: #selector(changeSort), for: .touchUpInside)

        if let cancelButton = homeView.searchBar.value(forKey: "cancelButton") as? UIButton {
            cancelButton.addTarget(self, action: #selector(cancelButtonTapped), for: .touchUpInside)
        }
    }

    private func setupNavigationUI() {
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = .green
        appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        appearance.shadowColor = .clear

        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.isTranslucent = false
        navigationItem.title = "이윤지's MEANING OUT"
    }

    // emptyImageView 설정
    private func setupEmptyImageView() {
           view.addSubview(emptyImageView)
           view.addSubview(emptyLabel)
           
           emptyImageView.snp.makeConstraints { make in
               make.center.equalToSuperview()
               make.width.height.equalTo(200)
           }
           
           emptyLabel.snp.makeConstraints { make in
               make.top.equalTo(emptyImageView.snp.bottom).offset(5)
               make.centerX.equalToSuperview()
           }
       }
    
    @objc private func cancelButtonTapped() {
        productItems.removeAll()
        homeView.collectionView.reloadData()
        updateEmptyImageViewVisibility()
        navigationController?.popViewController(animated: true)
    }

    @objc private func toggleButtonColor(sender: UIButton) {
        let allButtons = [homeView.accuracyButton, homeView.dateButton, homeView.upPriceButton, homeView.downPriceButton]
        for button in allButtons {
            button.isSelected = false
            button.backgroundColor = .gray
            button.setTitleColor(.red, for: .normal)
        }
        sender.isSelected.toggle()
        if sender.isSelected {
            sender.backgroundColor = .white
            sender.setTitleColor(.brown, for: .normal)
        }
    }

    @objc private func changeSort(sender: UIButton) {
        guard !isDataLoading else { return }
        guard let query = homeView.searchBar.text, !query.isEmpty else { return }

        var sortValue: String
        switch sender {
        case homeView.accuracyButton:
            sortValue = "sim"
        case homeView.dateButton:
            sortValue = "date"
        case homeView.upPriceButton:
            sortValue = "dsc"
        case homeView.downPriceButton:
            sortValue = "asc"
        default:
            return
        }

        productItems.removeAll()
        isDataLoading = true
        shopManager.shoppingRequest(query: query, sort: sortValue) { items in
            self.isDataLoading = false
            guard let items = items else { return }
            self.productItems.append(contentsOf: items)
            self.homeView.collectionView.reloadData()
            self.updateEmptyImageViewVisibility()
        }
    }
    
    func loadData(query: String, sort: String = "sim", display: Int = 30, start: Int = 1) {
          shopManager.shoppingRequest(query: query, display: display, start: start, sort: sort) { items in
              self.isDataLoading = false
              guard let items = items else { return }
              self.productItems.append(contentsOf: items)
              self.homeView.collectionView.reloadData()
              self.updateEmptyImageViewVisibility()
          }
      }
    // 검색 결과가 없을 때 emptyImageView를 표시하는 함수
       private func updateEmptyImageViewVisibility() {
           let isEmpty = productItems.isEmpty
                  emptyImageView.isHidden = !isEmpty
                  emptyLabel.isHidden = !isEmpty
       }
}

// MARK: - UISearchBarDelegate
extension HomeViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let text = homeView.searchBar.text, !text.trimmingCharacters(in: .whitespaces).isEmpty else { return }
        loadData(query: text)
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        productItems.removeAll()
        homeView.collectionView.reloadData()
        updateEmptyImageViewVisibility()
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            productItems.removeAll()
            homeView.collectionView.reloadData()
            updateEmptyImageViewVisibility()
        }
    }
}

// MARK: - UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDataSourcePrefetching
extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDataSourcePrefetching {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return productItems.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MainCollectionViewCell", for: indexPath) as? HomeCollectionViewCell else { return UICollectionViewCell() }
        let item = productItems[indexPath.row]
        cell.configure(with: item)
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        guard let query = homeView.searchBar.text, !isDataEnd else { return }

        if productItems.count - 1 == indexPaths.last?.row {
            pageStartNumber += 1
            shopManager.shoppingRequest(query: query, start: pageStartNumber) { items in
                guard let items = items else { return }
                self.productItems.append(contentsOf: items)
                self.homeView.collectionView.reloadData()
                self.updateEmptyImageViewVisibility()
            }
        }
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("셀클릭")
        let item = productItems[indexPath.row]
        let webVC = WebViewController()
        webVC.productID = item.productID
        webVC.item = item
        webVC.webViewTitle = item.title.replacingOccurrences(of: "<b>", with: "").replacingOccurrences(of: "</b>", with: "")
        navigationController?.pushViewController(webVC, animated: true)
    }
    
}
