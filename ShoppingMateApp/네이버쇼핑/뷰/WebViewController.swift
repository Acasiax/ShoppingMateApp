//
//  WebViewController.swift
//  ShoppingMateApp
//
//  Created by 이윤지 on 6/14/24.
//

import UIKit
import WebKit
import RealmSwift

class WebViewController: UIViewController, WKUIDelegate {
    var webView = WKWebView()
    var productID: String?
    var likeProductID: String?
    var webViewTitle: String?
    var item: Item?
    var likedProductItem: LikeTable?
   

    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupWebView()
        configureNavigationBar()
        loadWebView()
    }
    
    private func setupWebView() {
        let webConfiguration = WKWebViewConfiguration()
        webView = WKWebView(frame: .zero, configuration: webConfiguration)
        webView.uiDelegate = self
        view.addSubview(webView)
        
        webView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    private func configureNavigationBar() {
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = .red
        appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        navigationController?.navigationBar.isTranslucent = false
        
    }
    private func loadWebView() {
        
    }
    
}
