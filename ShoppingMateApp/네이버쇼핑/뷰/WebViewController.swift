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
    
    private func setupWebView() {}
    private func configureNavigationBar() {}
    private func loadWebView() {}
    
}
