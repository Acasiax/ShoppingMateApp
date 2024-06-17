//
//  favoriteTable.swift
//  ShoppingMateApp
//
//  Created by 이윤지 on 6/14/24.
//
import UIKit
import RealmSwift

protocol LikeTableRepositoryType: AnyObject {
    func fetchAll() -> Results<LikeTable>
    func saveItem(_ item: Item)
    func fetchUnliked() -> Results<LikeTable>
    func findFileURL() -> URL?
}

class LikeTableRepository: LikeTableRepositoryType {
    private let realm = try! Realm()
    
    func fetchAll() -> Results<LikeTable> {
        return realm.objects(LikeTable.self).sorted(byKeyPath: "likeDate", ascending: true)
    }

    func saveItem(_ item: Item) {
        if realm.objects(LikeTable.self).filter("title == %@", item.title).first == nil {
            let likeItem = LikeTable(title: item.title, image: item.image, price: item.lprice, mallName: item.mallName, likeDate: Date(), isLiked: true, productID: item.productID)
            try! realm.write {
                realm.add(likeItem)
            }
        }
    }

    func deleteItem<T: TitleProtocol>(_ item: T) {
        if let objectToDelete = realm.objects(LikeTable.self).filter("title == %@", item.title).first {
            try! realm.write {
                realm.delete(objectToDelete)
            }
        }
    }

    func fetchUnliked() -> Results<LikeTable> {
        return realm.objects(LikeTable.self).filter("isLiked == false")
    }

    func findFileURL() -> URL? {
        return realm.configuration.fileURL
    }
}
