//
//  WebViewController.swift
//  ShoppingMateApp
//
//  Created by 이윤지 on 6/14/24.
//

import Foundation
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
   var isLiked: Bool = false {
       didSet {
           updateLikeButtonImage()
       }
   }
   
    private let likedImageName = "like_selected"
    private let unlikedImageName = "like_unselected"
    
   override func viewDidLoad() {
       super.viewDidLoad()
       setupWebView()
       configureNavigationBar()
       loadWebView()
   }

   override func viewWillAppear(_ animated: Bool) {
       super.viewWillAppear(animated)
       checkIfProductIsLiked()
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
       navigationController?.navigationBar.scrollEdgeAppearance = appearance
       navigationController?.navigationBar.standardAppearance = appearance
       navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: likedImageName), style: .plain, target: self, action: #selector(detailLikeButtonTapped))
       navigationItem.title = webViewTitle
       navigationController?.navigationBar.tintColor = .white

       let backButton = UIButton(type: .system)
       backButton.setImage(UIImage(systemName: "chevron.backward"), for: .normal)
      // backButton.setTitle("뒤로", for: .normal)
       backButton.addTarget(self, action: #selector(backToMainView), for: .touchUpInside)
       backButton.tintColor = .white
       
       let backBarButtonItem = UIBarButtonItem(customView: backButton)
       navigationItem.leftBarButtonItem = backBarButtonItem

       let tabBarAppearance = UITabBarAppearance()
       tabBarAppearance.backgroundColor = .red
       self.tabBarController?.tabBar.standardAppearance = tabBarAppearance
       if #available(iOS 15.0, *) {
           self.tabBarController?.tabBar.scrollEdgeAppearance = tabBarAppearance
       }
   }

   private func loadWebView() {
       if let productID = productID {
           let urlString = "https://msearch.shopping.naver.com/product/\(productID)"
           if let url = URL(string: urlString) {
               let request = URLRequest(url: url)
               webView.load(request)
           }
       } else if let likeProductID = likeProductID {
           let urlString = "https://msearch.shopping.naver.com/product/\(likeProductID)"
           if let url = URL(string: urlString) {
               let request = URLRequest(url: url)
               webView.load(request)
           }
       }
   }

   @objc private func backToMainView() {
       navigationController?.popViewController(animated: true)
   }

   @objc private func detailLikeButtonTapped() {
       isLiked.toggle()
       let repository = LikeTableRepository()
       if isLiked {
           guard let item = self.item else { return }
           repository.saveItem(item)
       } else {
           if let item = self.item {
               repository.deleteItem(item)
           } else {
               guard let likeItem = self.likedProductItem else { return }
               repository.deleteItem(likeItem)
           }
       }
   }

    private func updateLikeButtonImage() {
        let imageName = isLiked ? likedImageName : unlikedImageName
        navigationItem.rightBarButtonItem?.image = UIImage(named: imageName)
    }

    private func checkIfProductIsLiked() {
        let repository = LikeTableRepository()
        let likedItems = repository.fetchAll()
        if let productID = self.productID {
            isLiked = likedItems.contains(where: { $0.productID == productID })
        } else if let likeProductID = self.likeProductID {
            isLiked = likedItems.contains(where: { $0.productID == likeProductID })
        } else {
            isLiked = false
        }
    }
 }


import Foundation
import UIKit
import WebKit
import RealmSwift

class WebViewController2: UIViewController, WKUIDelegate {
   var webView = WKWebView()
   var productID: String?
   var likeProductID: String?
   var webViewTitle: String?
   var item: Item?
   var likedProductItem: LikeTable?
   var isLiked: Bool = false {
       didSet {
           updateLikeButtonImage()
       }
   }
   
    private let likedImageName = "like_selected"
    private let unlikedImageName = "like_unselected"
    
   override func viewDidLoad() {
       super.viewDidLoad()
       setupWebView()
       configureNavigationBar()
       loadWebView()
   }

   override func viewWillAppear(_ animated: Bool) {
       super.viewWillAppear(animated)
       checkIfProductIsLiked()
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
       navigationController?.navigationBar.scrollEdgeAppearance = appearance
       navigationController?.navigationBar.standardAppearance = appearance
       navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: likedImageName), style: .plain, target: self, action: #selector(detailLikeButtonTapped))
       navigationItem.title = webViewTitle
       navigationController?.navigationBar.tintColor = .white

       let backButton = UIButton(type: .system)
       backButton.setImage(UIImage(systemName: "chevron.backward"), for: .normal)
      // backButton.setTitle("뒤로", for: .normal)
       backButton.addTarget(self, action: #selector(backToMainView), for: .touchUpInside)
       backButton.tintColor = .white
       
       let backBarButtonItem = UIBarButtonItem(customView: backButton)
       navigationItem.leftBarButtonItem = backBarButtonItem

       let tabBarAppearance = UITabBarAppearance()
       tabBarAppearance.backgroundColor = .red
       self.tabBarController?.tabBar.standardAppearance = tabBarAppearance
       if #available(iOS 15.0, *) {
           self.tabBarController?.tabBar.scrollEdgeAppearance = tabBarAppearance
       }
   }

   private func loadWebView() {
       if let productID = productID {
           let urlString = "https://msearch.shopping.naver.com/product/\(productID)"
           if let url = URL(string: urlString) {
               let request = URLRequest(url: url)
               webView.load(request)
           }
       } else if let likeProductID = likeProductID {
           let urlString = "https://msearch.shopping.naver.com/product/\(likeProductID)"
           if let url = URL(string: urlString) {
               let request = URLRequest(url: url)
               webView.load(request)
           }
       }
   }

   @objc private func backToMainView() {
       navigationController?.popViewController(animated: true)
   }

   @objc private func detailLikeButtonTapped() {
       isLiked.toggle()
       let repository = LikeTableRepository()
       if isLiked {
           guard let item = self.item else { return }
           repository.saveItem(item)
       } else {
           if let item = self.item {
               repository.deleteItem(item)
           } else {
               guard let likeItem = self.likedProductItem else { return }
               repository.deleteItem(likeItem)
           }
       }
   }

    private func updateLikeButtonImage() {
        let imageName = isLiked ? likedImageName : unlikedImageName
        navigationItem.rightBarButtonItem?.image = UIImage(named: imageName)
    }

    private func checkIfProductIsLiked() {
        let repository = LikeTableRepository()
        let likedItems = repository.fetchAll()
        if let productID = self.productID {
            isLiked = likedItems.contains(where: { $0.productID == productID })
        } else if let likeProductID = self.likeProductID {
            isLiked = likedItems.contains(where: { $0.productID == likeProductID })
        } else {
            isLiked = false
        }
    }
 }
