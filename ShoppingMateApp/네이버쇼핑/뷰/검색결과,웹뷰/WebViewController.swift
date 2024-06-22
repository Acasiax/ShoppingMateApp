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
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)
        
        
        let tabBarAppearance = UITabBarAppearance()
        self.tabBarController?.tabBar.standardAppearance = tabBarAppearance
        if #available(iOS 15.0, *) {
            self.tabBarController?.tabBar.scrollEdgeAppearance = tabBarAppearance
        }
    }

    private func loadWebView() {
        let productID = self.productID ?? self.likeProductID
        guard let productID = productID, let url = URL(string: "\(APIEndpoints.naverProduct)\(productID)") else { return }
        webView.load(URLRequest(url: url))
    }
    
    @objc private func backToMainView() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func detailLikeButtonTapped() {
        isLiked.toggle()
        
        guard let item = self.item else { return }
        var likedItems = FileManagerHelper.shared.loadLikedItems()
        if isLiked {
            let likedItem = LikedItem(mall: item.mallName, imageName: item.image, title: item.title, price: item.lprice)
            likedItems.append(likedItem)
        } else {
            likedItems.removeAll { $0.title == item.title }
        }
        FileManagerHelper.shared.saveLikedItems(likedItems)
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
        let productID = self.productID ?? self.likeProductID
        isLiked = likedItems.contains { $0.title == productID }
    }
    
    @objc private func handleLikeStatusChanged(notification: NSNotification) {
        guard let likedItem = notification.object as? Item else { return }
        if likedItem.productID == self.productID || likedItem.productID == self.likeProductID {
            checkIfProductIsLiked()
        }
    }
}
