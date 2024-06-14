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
    var productItems: [Item] = []
    var shopManager = NetworkManager.shared
    var favoriteItems: Results<LikeTable>!
    let realmDatabase = try! Realm()
    var isDataEnd = false
    var pageStartNumber = 1
    var isDataLoading = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    override func loadView() {
        self.view = homeView
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        homeView.collectionView.reloadData()
    }
  
    
    private func setupUI() {
        homeView.collectionView.delegate = self
        homeView.collectionView.dataSource = self
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
        }
    }
   
        
        func loadData(query: String, sort: String = "sim", display: Int = 30, start: Int = 1) {
              shopManager.shoppingRequest(query: query, display: display, start: start, sort: sort) { items in
                  self.isDataLoading = false
                  guard let items = items else { return }
                  self.productItems.append(contentsOf: items)
                 
              }
          }
    }
    



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
            }
        }
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = productItems[indexPath.row]
      
    }
}

    
    
    
    
    
    
    

