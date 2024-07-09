//
//  LikeNotification.swift
//  ShoppingMateApp
//
//  Created by 이윤지 on 6/15/24.
//

import Foundation

extension Notification.Name {
    static let likedItemsUpdated = Notification.Name("likedItemsUpdated")
}

protocol Reusable: AnyObject {
    static var reuseIdentifier: String { get }
}

extension Reusable {
    static var reuseIdentifier: String {
        return String(describing: self)
    }
}
