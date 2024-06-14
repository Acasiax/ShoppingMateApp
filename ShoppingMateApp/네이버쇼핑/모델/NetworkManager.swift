//
//  NetworkManager.swift
//  ShoppingMateApp
//
//  Created by 이윤지 on 6/14/24.
//

import UIKit
import Alamofire

class NetworkManager {
    static let shared = NetworkManager()
    private init() { }

    func shoppingRequest(query: String, display: Int = 30, start: Int = 1, sort: String = "sim", completion: @escaping ([Item]?) -> Void) {
        let url = "https://openapi.naver.com/v1/search/shop.json"
        let parameters: [String: Any] = ["query": query, "display": display, "start": start, "sort": sort]
        let headers: HTTPHeaders = [
            "X-Naver-Client-Id": APIKey.naverClientId,
            "X-Naver-Client-Secret": APIKey.naverClientSecret,
            "Content-Type": "application/json; charset=UTF-8"
        ]
        
        AF.request(url, method: .get, parameters: parameters, headers: headers).validate().responseDecodable(of: Shop.self) { response in
            switch response.result {
            case .success(let shop):
                completion(shop.items)
            case .failure(let error):
                print("Error: \(error)")
                completion(nil)
            }
        }
    }
}
