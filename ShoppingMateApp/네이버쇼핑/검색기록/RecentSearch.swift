//
//  RecentSearch.swift
//  ShoppingMateApp
//
//  Created by 이윤지 on 6/21/24.
//
//
import UIKit

//struct RecentSearch: Codable {
//    let searchTerm: String
//    let date: Date
//
//    init(searchTerm: String) {
//        self.searchTerm = searchTerm
//        self.date = Date()
//    }
//}

//class RecentSearchRepository {
//    private let fileManagerHelper = FileManagerHelper.shared
//
//    func fetchAll() -> [String] {
//        let searches = fileManagerHelper.loadRecentSearches().sorted(by: { $0.date > $1.date })
//        return searches.map { $0.searchTerm }
//    }
//
//    func saveSearch(_ searchTerm: String) {
//        var searches = fileManagerHelper.loadRecentSearches()
//        searches.append(RecentSearch(searchTerm: searchTerm))
//        fileManagerHelper.saveRecentSearches(searches)
//    }
//
//    func deleteSearch(_ searchTerm: String) {
//        var searches = fileManagerHelper.loadRecentSearches()
//        searches.removeAll { $0.searchTerm == searchTerm }
//        fileManagerHelper.saveRecentSearches(searches)
//    }
//
//    func deleteAll() {
//        fileManagerHelper.deleteAllRecentSearches()
//    }
//}


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
