//
//  MainTabBarController.swift
//  ShoppingMateApp
//
//  Created by 이윤지 on 6/16/24.
//

//import UIKit
//
//class MainTabBarController: UITabBarController {
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        
//        let homeVC = UINavigationController(rootViewController: HomeViewController())
//        homeVC.tabBarItem = UITabBarItem(title: "Home", image: UIImage(systemName: "house"), tag: 0)
//        
//        let likeVC = UINavigationController(rootViewController: LikeViewController())
//        likeVC.tabBarItem = UITabBarItem(title: "Likes", image: UIImage(systemName: "heart"), tag: 1)
//        
//        let settingsVC = UINavigationController(rootViewController: SettingViewController(navigationTitle: "설정정", showSaveButton: true))
//        settingsVC.tabBarItem = UITabBarItem(title: "Settings", image: UIImage(systemName: "gearshape"), tag: 2)
//        
//        viewControllers = [homeVC, likeVC, settingsVC]
//        
//        tabBar.tintColor = .white
//        tabBar.unselectedItemTintColor = .gray
//        tabBar.backgroundColor = .green
//    }
//}

import UIKit

class MainTabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTabBar()
        setupViewControllers()
    }
    
    private func setupTabBar() {
        tabBar.tintColor = .orange // 선택된 아이템의 색상
        tabBar.unselectedItemTintColor = .gray  // 선택되지 않은 아이템의 색상
        tabBar.backgroundColor = UIColor(red: 0.97, green: 0.98, blue: 0.98, alpha: 1.00)
    }
    
    private func setupViewControllers() {
        let homeVC = HomeViewController()
        let settingsVC = SettingViewController(navigationTitle: "세팅뷰우", showSaveButton: false)
        let likeVC = LikeViewController()
        
        let searchNavVC = UINavigationController(rootViewController: homeVC)
        searchNavVC.tabBarItem = UITabBarItem(title: "검색", image: UIImage(systemName: "magnifyingglass"), tag: 0)
        
        let settingsNavVC = UINavigationController(rootViewController: settingsVC)
        settingsNavVC.tabBarItem = UITabBarItem(title: "설정", image: UIImage(systemName: "gearshape"), tag: 1)
        
        let likeNavVC = UINavigationController(rootViewController: likeVC)
        likeNavVC.tabBarItem = UITabBarItem(title: "좋아요", image: UIImage(systemName: "heart"), tag: 2)
        
        setViewControllers([searchNavVC, settingsNavVC, likeNavVC], animated: false)
    }
}
