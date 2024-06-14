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
    
    func shoppingRequest(query: String, display: Int = 30, start: Int = 1, sort: String = "sim", completion: @escaping ([Item]?) -> Void) {
        let url = "https://openapi.naver.com/v1/search/shop.json"
        let parameters: [String: Any] = ["query": query, "display": display, "start": start, "sort": sort]
        let headers: HTTPHeaders = [
            "X-Naver-Client-Id": APIKey.naverClientId,
            "X-Naver-Client-Secret": APIKey.naverClientSecret,
            "Content-Type": "application/json; charset=UTF-8"
        ]
        
        func loadData(query: String, sort: String = "sim", display: Int = 30, start: Int = 1) {
              shopManager.shoppingRequest(query: query, display: display, start: start, sort: sort) { items in
                  self.isDataLoading = false
                  guard let items = items else { return }
                  self.productItems.append(contentsOf: items)
                 
              }
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
