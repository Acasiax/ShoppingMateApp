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
    var recentSearches: [String] = [] //최근 검색어
    
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
        label.font = .systemFont(ofSize: 17, weight: .bold)
            label.isHidden = true // 기본적으로 숨김
            return label
        }()
    
    // 최근 검색어를 표시할 테이블 뷰
       let recentSearchTableView: UITableView = {
           let tableView = UITableView()
           tableView.isHidden = true
           return tableView
       }()
    
    
    override func loadView() {
        self.view = homeView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
                view.addGestureRecognizer(tapGesture)
        tapGesture.cancelsTouchesInView = false // 🌟
        updateEmptyImageViewVisibility()
        updateRecentSearchVisibility()
        setupUI()
        setupEmptyImageView()
        setupRecentSearchTableView()
        print(realmDatabase.configuration.fileURL)
        print(realmDatabase.configuration.fileURL ?? "램 URL 값이 닐 입니다ㅠㅜ")
    }

    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        updateEmptyImageViewVisibility()
        homeView.collectionView.reloadData()
        
        updateRecentSearchVisibility()
        
        
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
               make.top.equalTo(emptyImageView.snp.bottom).offset(8)
               make.centerX.equalToSuperview()
           }
       }
    
    private func setupRecentSearchTableView() {
            view.addSubview(recentSearchTableView)
            recentSearchTableView.delegate = self
            recentSearchTableView.dataSource = self
            recentSearchTableView.register(UITableViewCell.self, forCellReuseIdentifier: "RecentSearchCell")
            
            recentSearchTableView.snp.makeConstraints { make in
                make.top.equalTo(homeView.searchBar.snp.bottom)
                make.left.right.equalToSuperview()
                make.bottom.equalToSuperview()
            }
        }
    
    @objc private func cancelButtonTapped() {
        productItems.removeAll()
        homeView.collectionView.reloadData()
        updateEmptyImageViewVisibility()
        updateRecentSearchVisibility() 
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
        print(" \(#function) 함수 입니다")
          shopManager.shoppingRequest(query: query, display: display, start: start, sort: sort) { items in
              self.isDataLoading = false
              guard let items = items else { return }
              self.productItems.append(contentsOf: items)
              self.homeView.collectionView.reloadData()
              self.updateEmptyImageViewVisibility()
          }
      }
    // 검색 결과가 없을 때 emptyImageView를 표시하는 함수
        func updateEmptyImageViewVisibility() {
            print(" \(#function) 함수 입니다")
           let isEmpty = productItems.isEmpty
                  emptyImageView.isHidden = !isEmpty
                  emptyLabel.isHidden = !isEmpty
            recentSearchTableView.isHidden = !recentSearches.isEmpty || !isEmpty // 🌟 최근 검색어가 있을 때는 emptyImageView를 숨김
            recentSearchTableView.reloadData()
       }
    // 최근 검색어 표시 여부 업데이트 함수
        func updateRecentSearchVisibility() {
            print(" \(#function) 함수 입니다")
           recentSearchTableView.isHidden = recentSearches.isEmpty
           recentSearchTableView.reloadData()
       }
}

// MARK: - UISearchBarDelegate
extension HomeViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        print(" \(#function) 함수 입니다")
        guard let text = homeView.searchBar.text, !text.trimmingCharacters(in: .whitespaces).isEmpty else { return }
        loadData(query: text)
        addRecentSearch(text)
        recentSearchTableView.isHidden = true // 🌟 검색 시작 시 테이블 뷰 숨김
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        print(" \(#function) 함수 입니다")
        productItems.removeAll()
        homeView.collectionView.reloadData()
        updateEmptyImageViewVisibility()
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print(" \(#function) 함수 입니다")
        if searchText.isEmpty {
            productItems.removeAll()
            homeView.collectionView.reloadData()
            updateEmptyImageViewVisibility()
           
           
        }
    }
    
    private func addRecentSearch(_ searchText: String) {
        print(" \(#function) 함수 입니다")
           if !recentSearches.contains(searchText) {
               recentSearches.insert(searchText, at: 0)
               if recentSearches.count > 10 {
                   recentSearches.removeLast()
               }
           }
        updateRecentSearchVisibility()
       }
    
}


