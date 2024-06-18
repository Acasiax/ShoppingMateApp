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
    
    func shoppingRequest(query: String, display: Int = 30, start: Int = 1, sort: String = "sim", completion: @escaping (Int?, [Item]?) -> Void) {
            let url = APIEndpoints.naverShopping
            let parameters: [String: Any] = ["query": query, "display": display, "start": start, "sort": sort]
            
            var headers = APIHeaders.commonHeaders
            headers.add(name: "X-Naver-Client-Id", value: APIKey.naverClientId)
            headers.add(name: "X-Naver-Client-Secret", value: APIKey.naverClientSecret)
            
            AF.request(url, method: .get, parameters: parameters, headers: headers).validate().responseDecodable(of: Shop.self) { response in
                switch response.result {
                case .success(let shop):
                    completion(shop.total, shop.items)
                    print("Total총 검색 수: \(shop.total)")
                    print(response.result)
                case .failure(let error):
                    print("Error에러: \(error)")
                    completion(nil, nil)
                    }
                }
            }
        }
