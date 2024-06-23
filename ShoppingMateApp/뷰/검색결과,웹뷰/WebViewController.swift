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
    var currentProductID: String?
    var likeProductID: String?
    var pageTitle: String?
    var currentItem: Item?
    var isLiked: Bool = false {
        didSet {
            updateIntoCartButtonImage()
        }
    }
    
    private let likedImageName = "like_selected"
    private let unlikedImageName = "like_unselected"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupWebView()
        configureNavigationBar()
        loadWebView()
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleCartStatusChanged), name: NSNotification.Name("LikeStatusChanged"), object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        verifyProductLikeStatus()
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
        navigationController?.navigationBar.applyCustomAppearance(
            backgroundColor: .customWhite,
            titleColor: .customBlack,
            tintColor: .customBlack
        )
        
        configureNavigationBar(
            title: pageTitle,
            rightButtonImage: UIImage(named: "profile_2"),
            rightButtonAction: #selector(detailCartButtonTapped),
            leftButtonAction: #selector(movingBackView)
        )
        
        let tabBarAppearance = UITabBarAppearance()
        self.tabBarController?.tabBar.standardAppearance = tabBarAppearance
        if #available(iOS 15.0, *) {
            self.tabBarController?.tabBar.scrollEdgeAppearance = tabBarAppearance
        }
    }
    
    private func loadWebView() {
        let productID = self.currentProductID ?? self.likeProductID
        guard let productID = productID, let url = URL(string: "\(APIEndpoints.naverProduct)\(productID)") else { return }
        webView.load(URLRequest(url: url))
    }
    
    @objc private func movingBackView() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func detailCartButtonTapped() {
        isLiked.toggle()
        
        guard let item = self.currentItem else { return }
        var likedItems = FileManagerHelper.shared.loadLikedItems()
        if isLiked {
            let likedItem = LikedItem(mall: item.mallName, imageName: item.image, title: item.title, price: item.lprice)
            likedItems.append(likedItem)
        } else {
            likedItems.removeAll { $0.title == item.title }
        }
        FileManagerHelper.shared.saveLikedItems(likedItems)
        
        // 좋아요 상태 변경에 대한 Notification 전송
           NotificationCenter.default.post(name: NSNotification.Name("LikeStatusChanged"), object: nil)
        
    }
    
    private func updateIntoCartButtonImage() {
        let imageName = isLiked ? likedImageName : unlikedImageName
        if let image = UIImage(named: imageName)?.withRenderingMode(.alwaysOriginal) {
            navigationItem.rightBarButtonItem?.image = image
        } else {
            print("네비게이션 이미지로드에 실패: \(imageName)")
        }
    }
    
    private func verifyProductLikeStatus() {
        let likedItems = FileManagerHelper.shared.loadLikedItems()
        let productID = self.currentProductID ?? self.likeProductID
        isLiked = likedItems.contains { $0.title == productID }
    }
    
    @objc private func handleCartStatusChanged(notification: NSNotification) {
        guard let likedItem = notification.object as? Item else { return }
        if likedItem.productID == self.currentProductID || likedItem.productID == self.likeProductID {
            verifyProductLikeStatus()
        }
    }
}
