//
//  LikeTable.swift
//  ShoppingMateApp
//
//  Created by 이윤지 on 6/14/24.
//
import UIKit
import RealmSwift

class LikeTable: Object, TitleProtocol {
    @Persisted(primaryKey: true) var id: ObjectId
    @Persisted var title: String
    @Persisted var image: String
    @Persisted var price: String
    @Persisted var mallName: String
    @Persisted var likeDate: Date
    @Persisted var isLiked: Bool
    @Persisted var productID: String

    convenience init(title: String, image: String, price: String, mallName: String, likeDate: Date, isLiked: Bool, productID: String) {
        self.init()
        self.title = title
        self.image = image
        self.price = price
        self.mallName = mallName
        self.likeDate = likeDate
        self.isLiked = isLiked
        self.productID = productID
    }
}




protocol TitleProtocol {
    var title: String { get }
}

