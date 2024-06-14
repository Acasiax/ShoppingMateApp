//
//  Item.swift
//  ShoppingMateApp
//
//  Created by 이윤지 on 6/14/24.
//

import UIKit

struct Shop: Codable {
    let start, display: Int
    let items: [Item]
}

struct Item: Codable, TitleProtocol {
    let title: String
    let image: String
    let lprice: String
    let hprice: String
    let mallName: String
    let productID: String

    enum CodingKeys: String, CodingKey {
        case title, image, lprice, hprice, mallName
        case productID = "productId"
    }
}
