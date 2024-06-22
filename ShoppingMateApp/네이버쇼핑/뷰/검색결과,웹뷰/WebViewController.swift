//
//  WebViewController.swift
//  ShoppingMateApp
//
//  Created by 이윤지 on 6/14/24.
//
import UIKit
import WebKit

class WebViewController: UIViewController, WKUIDelegate {
    var webView = WKWebView()
    var productID: String?
    var likeProductID: String?
    var webViewTitle: String?
    var item: Item?
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
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleLikeStatusChanged), name: NSNotification.Name("LikeStatusChanged"), object: nil)
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
        appearance.backgroundColor = .customWhite
        appearance.titleTextAttributes = [.foregroundColor: UIColor.customBlack]
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        navigationController?.navigationBar.standardAppearance = appearance
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "profile_2"), style: .plain, target: self, action: #selector(detailLikeButtonTapped))
        navigationItem.title = webViewTitle
        navigationController?.navigationBar.tintColor = .customBlack

        let backButton = UIButton(type: .system)
        backButton.setImage(UIImage(systemName: "chevron.backward"), for: .normal)
        backButton.addTarget(self, action: #selector(backToMainView), for: .touchUpInside)
        backButton.tintColor = UIColor.customBlack
        
        let backBarButtonItem = UIBarButtonItem(customView: backButton)
        navigationItem.leftBarButtonItem = backBarButtonItem

        let tabBarAppearance = UITabBarAppearance()
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
       
        if isLiked {
            guard let item = self.item else { return }
            var likedItems = FileManagerHelper.shared.loadLikedItems()
            let likedItem = LikedItem(mall: item.mallName, imageName: item.image, title: item.title, price: item.lprice)
            likedItems.append(likedItem)
            FileManagerHelper.shared.saveLikedItems(likedItems)
        } else {
            var likedItems = FileManagerHelper.shared.loadLikedItems()
            likedItems.removeAll { $0.title == item?.title }
            FileManagerHelper.shared.saveLikedItems(likedItems)
        }
     //   NotificationCenter.default.post(name: NSNotification.Name("LikeStatusChanged"), object: item)
    }


    
    private func updateLikeButtonImage() {
            let imageName = isLiked ? likedImageName : unlikedImageName
            if let image = UIImage(named: imageName)?.withRenderingMode(.alwaysOriginal) {
                navigationItem.rightBarButtonItem?.image = image
            } else {
                print("네비게이션 이미지로드에 실패: \(imageName)")
            }
        }

    private func checkIfProductIsLiked() {
        let likedItems = FileManagerHelper.shared.loadLikedItems()
        if let productID = self.productID {
            isLiked = likedItems.contains(where: { $0.title == productID })
        } else if let likeProductID = self.likeProductID {
            isLiked = likedItems.contains(where: { $0.title == likeProductID })
        } else {
            isLiked = false
        }
    }
    
    @objc private func handleLikeStatusChanged(notification: NSNotification) {
        guard let likedItem = notification.object as? Item else { return }
        if likedItem.productID == self.productID || likedItem.productID == self.likeProductID {
            checkIfProductIsLiked()
        }
    }
}
