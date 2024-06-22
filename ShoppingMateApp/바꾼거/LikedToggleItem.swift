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
    let mall: String
    let imageName: String
    let title: String
    let price: String
}

struct RecentSearch: Codable {
    let searchTerm: String
}

class FileManagerHelper {
    static let shared = FileManagerHelper()
    
    private let likedItemsFileName = "likedItems.json"
    private let recentSearchesFileName = "recentSearches.json"
    
    private var likedItemsFileURL: URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0].appendingPathComponent(likedItemsFileName)
    }
    
    private var recentSearchesFileURL: URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0].appendingPathComponent(recentSearchesFileName)
    }
    
    // 좋아요 항목 저장 및 불러오기
    func saveLikedItems(_ items: [LikedItem]) {
        do {
            let data = try JSONEncoder().encode(items)
            try data.write(to: likedItemsFileURL)
            print("좋아요 항목 저장 성공")
        } catch {
            print("좋아요 항목 저장 실패: \(error)")
        }
    }
    
    func loadLikedItems() -> [LikedItem] {
        do {
            let fileManager = FileManager.default
            if !fileManager.fileExists(atPath: likedItemsFileURL.path) {
                return []  // 파일이 존재하지 않으면 빈 배열 반환
            }
            
            let data = try Data(contentsOf: likedItemsFileURL)
            let items = try JSONDecoder().decode([LikedItem].self, from: data)
            return items
        } catch {
            print("좋아요 항목 불러오기 실패: \(error)")
            return []
        }
    }
    
    // 최근 검색어 저장 및 불러오기
    func saveRecentSearches(_ searches: [RecentSearch]) {
        do {
            let data = try JSONEncoder().encode(searches)
            try data.write(to: recentSearchesFileURL)
            print("최근 검색어 저장 성공")
        } catch {
            print("최근 검색어 저장 실패: \(error)")
        }
    }

    func loadRecentSearches() -> [RecentSearch] {
        do {
            let fileManager = FileManager.default
            if !fileManager.fileExists(atPath: recentSearchesFileURL.path) {
                return []  // 파일이 존재하지 않으면 빈 배열 반환
            }
            let data = try Data(contentsOf: recentSearchesFileURL)
            let searches = try JSONDecoder().decode([RecentSearch].self, from: data)
            return searches
        } catch {
            print("최근 검색어 불러오기 실패: \(error)")
            return []
        }
    }
    func printLikedItemsCount() {
                let likedItems = loadLikedItems()
                print("👩‍🌾현재 저장된 좋아요 항목 개수: \(likedItems.count)개")
            }
    
    func deleteAllRecentSearches() {
        saveRecentSearches([])
    }
}



protocol TitleProtocol {
    var title: String { get }
}
