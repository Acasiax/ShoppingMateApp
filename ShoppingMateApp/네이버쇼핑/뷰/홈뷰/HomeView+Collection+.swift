//
//  HomeView+Collection+.swift
//  ShoppingMateApp
//
//  Created by 이윤지 on 6/14/24.
//
import UIKit
import SnapKit

// MARK: - UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDataSourcePrefetching
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
            
            shopManager.shoppingRequest(query: query, start: pageStartNumber) { total, items in
                            guard let items = items else { return }
                            self.productItems.append(contentsOf: items)
                            self.homeView.collectionView.reloadData()
                            self.updateEmptyImageViewVisibility()
                        }
        }
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = productItems[indexPath.row]
        let webVC = WebViewController()
        webVC.productID = item.productID
        webVC.item = item
        webVC.webViewTitle = item.title.replacingOccurrences(of: "<b>", with: "").replacingOccurrences(of: "</b>", with: "")
        navigationController?.pushViewController(webVC, animated: true)
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recentSearches.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RecentSearchCell", for: indexPath)
        cell.textLabel?.text = recentSearches[indexPath.row]
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard !isSearching else { return }
        isSearching = true
        let selectedSearch = recentSearches[indexPath.row]
        homeView.searchBar.text = selectedSearch
        
        navigateToSearchResults(query: selectedSearch)
        recentSearchTableView.isHidden = true // 검색 시작 시 테이블 뷰 숨김
    }

    // 최근 검색어 삭제 기능 (선택 사항)
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            recentSearches.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            updateRecentSearchVisibility()
        }
    }
}
