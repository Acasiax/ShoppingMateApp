//
//  RecentSearch.swift
//  ShoppingMateApp
//
//  Created by 이윤지 on 6/21/24.
//
//
import UIKit

class RecentSearchRepository {
    func saveSearch(_ searchTerm: String) {
        var searches = FileManagerHelper.shared.loadRecentSearches()
        searches.append(RecentSearch(searchTerm: searchTerm))
        FileManagerHelper.shared.saveRecentSearches(searches)
    }
    
    func fetchAll() -> [RecentSearch] {
        return FileManagerHelper.shared.loadRecentSearches()
    }
    
    func deleteSearch(_ searchTerm: String) {
        var searches = FileManagerHelper.shared.loadRecentSearches()
        searches.removeAll { $0.searchTerm == searchTerm }
        FileManagerHelper.shared.saveRecentSearches(searches)
    }
    
    func deleteAll() {
        FileManagerHelper.shared.deleteAllRecentSearches()
    }
}
