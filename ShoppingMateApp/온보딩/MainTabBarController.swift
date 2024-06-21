//
//  MainTabBarController.swift
//  ShoppingMateApp
//
//  Created by 이윤지 on 6/16/24.
//

import UIKit

class MainTabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTabBar()
        setupViewControllers()
    }
    
    private func setupTabBar() {
        tabBar.tintColor = .customOrange // 선택된 아이템의 색상
        tabBar.unselectedItemTintColor = .customGray8282  // 선택되지 않은 아이템의 색상
        tabBar.backgroundColor = UIColor(red: 0.97, green: 0.98, blue: 0.98, alpha: 1.00)
    }
    
    private func setupViewControllers() {
        let homeVC = HomeViewController()
        let settingsVC = SettingViewController(navigationTitle: "세팅뷰우", showSaveButton: false)
        let likeVC = ThreeCollectionViewController()
        
        let searchNavVC = UINavigationController(rootViewController: homeVC)
        searchNavVC.tabBarItem = UITabBarItem(title: "검색", image: UIImage(systemName: "magnifyingglass"), tag: 0)
        
        let settingsNavVC = UINavigationController(rootViewController: settingsVC)
        settingsNavVC.tabBarItem = UITabBarItem(title: "설정", image: UIImage(systemName: "gearshape"), tag: 1)
        
     //   let likeNavVC = UINavigationController(rootViewController: likeVC)
       // likeNavVC.tabBarItem = UITabBarItem(title: "좋아요", image: UIImage(systemName: "heart"), tag: 2)
           let likeNavVC = UINavigationController(rootViewController: likeVC)
           likeNavVC.tabBarItem = UITabBarItem(title: "좋아요", image: UIImage(systemName: "heart"), tag: 2)
        
        setViewControllers([searchNavVC, settingsNavVC, likeNavVC], animated: false)
    }
}
