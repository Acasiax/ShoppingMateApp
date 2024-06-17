//
//  ToasetMessage.swift
//  ShoppingMateApp
//
//  Created by 이윤지 on 6/17/24.
//

import UIKit
import Alamofire
import Toast

class ToastMGViewController: UIViewController {
    
    let reachabilityManager = NetworkReachabilityManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .customWhite
        
        startNetworkReachabilityObserver()
        
        let url = "https://example.com/data"
        fetchData(from: url)
    }
    
    func fetchData(from url: String) {
        AF.request(url).responseData { response in
            switch response.result {
            case .success(let data):
                // 데이터 처리
                self.handleSuccess(data: data)
                
            case .failure(let error):
                // 에러 처리 - 커스텀 토스트 메시지 표시
                self.showCustomToast(message: "네트워크 오류: \(error.localizedDescription)")
            }
        }
    }
    
    func handleSuccess(data: Data) {
        // 성공적인 데이터 처리 로직
    }
    
    func showCustomToast(message: String) {
        var style = ToastStyle()
        
        // 커스텀 스타일 설정
        style.backgroundColor = .customBlack.withAlphaComponent(0.8)
        style.messageColor = .customWhite
        style.messageAlignment = .center
        style.cornerRadius = 10.0
        //style.font = UIFont.systemFont(ofSize: 16.0, weight: .medium)
        style.messageFont = UIFont.boldSystemFont(ofSize: 14.0)
        style.verticalPadding = 12.0
        style.horizontalPadding = 16.0
        
        // 아이콘 추가
        let toastIcon = UIImage(named: "error_icon")
        self.view.makeToast(message, duration: 3.0, position: .bottom, title: nil, image: toastIcon, style: style, completion: nil)
    }
    
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "확인", style: .default, handler: nil)
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    func startNetworkReachabilityObserver() {
        reachabilityManager?.startListening { status in
            switch status {
            case .notReachable:
                self.showCustomToast(message: "네트워크 연결이 없습니다.")
            case .reachable(.cellular), .reachable(.ethernetOrWiFi):
                // 네트워크 연결이 다시 되었을 때의 처리
                break
            case .unknown:
                self.showCustomToast(message: "네트워크 상태를 확인할 수 없습니다.")
            }
        }
    }
    
    deinit {
        reachabilityManager?.stopListening()
    }
}
