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
             
             navigationController?.navigationBar.standardAppearance = appearance
             navigationController?.navigationBar.scrollEdgeAppearance = appearance
             navigationController?.navigationBar.isTranslucent = false
             
             // Set the title
             self.title = webViewTitle
             
             // Add the 'like' button
             let likeButton = UIBarButtonItem(image: UIImage(systemName: "heart"), style: .plain, target: self, action: #selector(didTapLikeButton))
             likeButton.tintColor = .white
             navigationItem.rightBarButtonItem = likeButton
        
    }
    private func loadWebView() {
        
    }
    
}
