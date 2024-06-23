//
//  WebViewController.swift
//  ShoppingMateApp
//
//  Created by 이윤지 on 6/14/24.
//
import UIKit
import WebKit

class WebViewController: UIViewController, WKUIDelegate {
    var mainWebView = WKWebView()
    var pageTitle: String?
    var currentProductID: String?
    var likedProductID: String?
    var currentItem: Item?
    private let likedImageName = "like_selected"
    private let unlikedImageName = "like_unselected"
    var isInCart: Bool = false {
        didSet {
            updateIsinCartButtonImage()
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupWebView()
        configureNavigationBar()
        loadWebView()
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleLikeStatusChanged), name: NSNotification.Name("LikeStatusChanged"), object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateCartStatus()
    }
    
    private func setupWebView() {
        let webConfiguration = WKWebViewConfiguration()
        mainWebView = WKWebView(frame: .zero, configuration: webConfiguration)
        mainWebView.uiDelegate = self
        view.addSubview(mainWebView)
        
        mainWebView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    private func loadWebView() {
        let productID = self.currentProductID ?? self.likedProductID
        guard let productID = productID, let url = URL(string: "\(APIEndpoints.naverProduct)\(productID)") else { return }
        mainWebView.load(URLRequest(url: url))
    }
    
    @objc private func backToMainView() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func toggleCartStatus() {
        isInCart.toggle()
        
        guard let item = self.currentItem else { return }
        var likedItems = FileManagerHelper.shared.loadLikedItems()
        if isInCart {
            let likedItem = LikedItem(mall: item.mallName, imageName: item.image, title: item.title, price: item.lprice)
            likedItems.append(likedItem)
        } else {
            likedItems.removeAll { $0.title == item.title }
        }
        FileManagerHelper.shared.saveLikedItems(likedItems)
    }
 
    private func updateIsinCartButtonImage() {
        let imageName = isInCart ? likedImageName : unlikedImageName
        if let image = UIImage(named: imageName)?.withRenderingMode(.alwaysOriginal) {
            navigationItem.rightBarButtonItem?.image = image
        } else {
            print("네비게이션 이미지로드에 실패: \(imageName)")
        }
    }
    
    private func updateCartStatus() {
        let likedItems = FileManagerHelper.shared.loadLikedItems()
        let productID = self.currentProductID ?? self.likedProductID
        isInCart = likedItems.contains { $0.title == productID }
    }
    
    @objc private func handleLikeStatusChanged(notification: NSNotification) {
        guard let likedItem = notification.object as? Item else { return }
        if likedItem.productID == self.currentProductID || likedItem.productID == self.likedProductID {
            updateCartStatus()
        }
    }
    
    private func configureNavigationBar() {
        let rightBarButtonImage = UIImage(named: "profile_2")
        let leftBarButtonImage = UIImage(systemName: "chevron.backward")
        navigationController?.configureAppearance(
            withTitle: pageTitle,
            rightBarButtonImage: rightBarButtonImage,
            rightBarButtonAction: #selector(toggleCartStatus),
            target: self,
            leftBarButtonImage: leftBarButtonImage,
            leftBarButtonAction: #selector(backToMainView)
        )
        
        let tabBarAppearance = UITabBarAppearance()
        tabBarController?.tabBar.standardAppearance = tabBarAppearance
        if #available(iOS 15.0, *) {
            tabBarController?.tabBar.scrollEdgeAppearance = tabBarAppearance
        }
    }
}
