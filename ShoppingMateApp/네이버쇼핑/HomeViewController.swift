//
//  HomeViewController.swift
//  ShoppingMateApp
//
//  Created by 이윤지 on 6/14/24.
//

import UIKit
import Alamofire

class HomeViewController: UIViewController {
    let homeView = MainSearchView()
    var productItems: [Item] = []
    var shopManager = NetworkManager.shared
    var isDataLoading = false
    var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    

    private func setupUI() {
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
    



extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MainCollectionViewCell", for: indexPath) as? HomeCollectionViewCell else { return UICollectionViewCell() }
        return cell
    }
    
//    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
//        let item = productItems[indexPath.row]
//    }
    
    
    
    
    
    
    
}
