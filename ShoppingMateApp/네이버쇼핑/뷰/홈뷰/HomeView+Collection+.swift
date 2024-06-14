//
//  HomeView+Collection+.swift
//  ShoppingMateApp
//
//  Created by 이윤지 on 6/14/24.
//

import UIKit
import SnapKit

// MARK: - UISearchBarDelegate
extension HomeViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let text = homeView.searchBar.text, !text.trimmingCharacters(in: .whitespaces).isEmpty else { return }
        loadData(query: text)
        addRecentSearch(text)
        recentSearchTableView.isHidden = true // 🌟 검색 시작 시 테이블 뷰 숨김
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
    
    private func addRecentSearch(_ searchText: String) {
        if !recentSearches.contains(searchText) {
            recentSearches.insert(searchText, at: 0)
            if recentSearches.count > 10 {
                recentSearches.removeLast()
            }
        }
        updateRecentSearchVisibility()
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
        let selectedSearch = recentSearches[indexPath.row]
        homeView.searchBar.text = selectedSearch
        loadData(query: selectedSearch)
        recentSearchTableView.isHidden = true // 🌟 검색 시작 시 테이블 뷰 숨김
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
