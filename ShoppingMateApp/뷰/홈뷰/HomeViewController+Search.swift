//
//  HomeViewController+Search.swift
//  ShoppingMateApp
//
//  Created by 이윤지 on 6/22/24.
//

import UIKit

extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDataSourcePrefetching {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return productItems.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MainCollectionViewCell", for: indexPath) as? HomeCollectionViewCell else {
            return UICollectionViewCell()
        }
        let item = productItems[indexPath.row]
        cell.configure(with: item)
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        guard let query = homeView.searchBar.text, !isDataEnd, !isDataLoading else { return }

        if productItems.count - 1 == indexPaths.last?.row {
            fetchMoreData(query: query)
        }
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = productItems[indexPath.row]
        let webVC = WebViewController()
        webVC.currentProductID = item.productID
        webVC.currentItem = item
        webVC.pageTitle = item.title.replacingOccurrences(of: "<b>", with: "").replacingOccurrences(of: "</b>", with: "")
        navigationController?.pushViewController(webVC, animated: true)
    }
    
    private func fetchMoreData(query: String) {
        isDataLoading = true
        pageStartNumber += 1
        
        shopManager.shoppingRequest(query: query, start: pageStartNumber) { [weak self] result in
            guard let self = self else { return }
            self.isDataLoading = false
            
            switch result {
            case .success(let (total, items)):
                let newIndexPaths = (self.productItems.count..<(self.productItems.count + items.count)).map { IndexPath(row: $0, section: 0) }
                self.productItems.append(contentsOf: items)
                
                DispatchQueue.main.async {
                    self.homeView.collectionView.insertItems(at: newIndexPaths)
                    self.updateVisibility()
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    AlertHelper.showErrorAlert(on: self, message: error.localizedDescription)
                }
            }
        }
    }

}
