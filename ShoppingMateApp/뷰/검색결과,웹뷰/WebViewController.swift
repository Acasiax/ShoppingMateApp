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
        //받는거
        NotificationCenter.default.addObserver(self, selector: #selector(handleCartStatusChanged), name: NSNotification.Name("LikeStatusChanged"), object: nil)
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        verifyProductLikeStatus()
    }
    
    
    @objc private func handleLikeStatusChangedInCell(notification: NSNotification) {
        // ⭐️ 셀의 좋아요 상태 변경을 처리
        guard let likedItem = notification.object as? Item else { return }
        if likedItem.productID == self.currentProductID || likedItem.productID == self.likeProductID {
            verifyProductLikeStatus()
            
        }
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
    
    //네비 바 버튼
    private func configureNavigationBar() {
        navigationController?.navigationBar.applyCustomAppearance(
            backgroundColor: .customWhite,
            titleColor: .customBlack,
            tintColor: .customBlack
        )
        
        configureNavigationBar(
            title: pageTitle,
            rightButtonImage: UIImage(named: unlikedImageName),
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
        print("좋아요 상태 토글됨: \(isLiked)")
        guard let item = self.currentItem else { return }
        var likedItems = FileManagerHelper.shared.loadLikedItems()
        if isLiked {
            let likedItem = LikedItem(mall: item.mallName, imageName: item.image, title: item.title, price: item.lprice)
            likedItems.append(likedItem)
        } else {
            print("🥳 \(item.title),🥕 \(item.productID)")
            likedItems.removeAll { $0.title == item.title }
        }
        FileManagerHelper.shared.saveLikedItems(likedItems)
        
        // 보내는 거
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
        print("현재 상품 ID: \(productID ?? "없음")")
        print("좋아요된 항목: \(likedItems.map { $0.title })")
        isLiked = likedItems.contains { $0.title == productID }
        print("좋아요 상태: \(isLiked)")
    }
    
    @objc private func handleCartStatusChanged(notification: NSNotification) {
        guard let likedItem = notification.object as? Item else { return }
        print("Notification 수신됨: \(likedItem.title)")
        if likedItem.productID == self.currentProductID || likedItem.productID == self.likeProductID {
            verifyProductLikeStatus()
        }
    }
}
