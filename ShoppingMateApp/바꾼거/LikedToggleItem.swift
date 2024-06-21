//
//  LikedToggleItem.swift
//  RecapShop
//
//  Created by 이윤지 on 6/21/24.
//
import Foundation
import UIKit
import SwiftData


struct LikedItem: Codable {
    let imageName: String
    let title: String
    let price: String
}

class FileManagerHelper {
    static let shared = FileManagerHelper()
    
    private let fileName = "likedItems.json"
    
    private var fileURL: URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0].appendingPathComponent(fileName)
    }
    
    func saveLikedItems(_ items: [LikedItem]) {
        do {
            let data = try JSONEncoder().encode(items)
            try data.write(to: fileURL)
            print("좋아요 항목 저장 성공")
        } catch {
            print("좋아요 항목 저장 실패: \(error)")
        }
    }
    
    func loadLikedItems() -> [LikedItem] {
        do {
            let fileManager = FileManager.default
            if !fileManager.fileExists(atPath: fileURL.path) {
                return []  // 파일이 존재하지 않으면 빈 배열 반환
            }
            
            let data = try Data(contentsOf: fileURL)
            let items = try JSONDecoder().decode([LikedItem].self, from: data)
            return items
        } catch {
            print("좋아요 항목 불러오기 실패: \(error)")
            return []
        }
    }
    
    func printLikedItemsCount() {
            let likedItems = loadLikedItems()
            print("👩‍🌾현재 저장된 좋아요 항목 개수: \(likedItems.count)개")
        }
    
}

protocol TitleProtocol {
    var title: String { get }
}
