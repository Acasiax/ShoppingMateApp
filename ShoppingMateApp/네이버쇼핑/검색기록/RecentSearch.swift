//
//  RecentSearch.swift
//  ShoppingMateApp
//
//  Created by 이윤지 on 6/21/24.
//
//
import UIKit
import RealmSwift

class RecentSearch: Object {
    @Persisted(primaryKey: true) var id: ObjectId
    @Persisted var searchTerm: String
    @Persisted var date: Date
    
    convenience init(searchTerm: String) {
        self.init()
        self.searchTerm = searchTerm
        self.date = Date()
    }
}

class RecentSearchRepository {
    private let realm = try! Realm()
    
    func fetchAll() -> [String] {
        let searches = realm.objects(RecentSearch.self).sorted(byKeyPath: "date", ascending: false)
        return Array(searches.map { $0.searchTerm })
    }
    
    func saveSearch(_ searchTerm: String) {
        let recentSearch = RecentSearch(searchTerm: searchTerm)
        try! realm.write {
            realm.add(recentSearch, update: .all)
        }
    }
    
    func deleteSearch(_ searchTerm: String) {
        if let objectToDelete = realm.objects(RecentSearch.self).filter("searchTerm == %@", searchTerm).first {
            try! realm.write {
                realm.delete(objectToDelete)
            }
        }
    }
    
    func deleteAll() {
        try! realm.write {
            realm.delete(realm.objects(RecentSearch.self))
        }
    }
}
