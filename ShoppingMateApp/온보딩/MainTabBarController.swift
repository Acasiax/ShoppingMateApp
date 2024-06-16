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
        
        let homeVC = UINavigationController(rootViewController: HomeViewController())
        homeVC.tabBarItem = UITabBarItem(title: "Home", image: UIImage(systemName: "house"), tag: 0)
        
        let likeVC = UINavigationController(rootViewController: LikeViewController())
        likeVC.tabBarItem = UITabBarItem(title: "Likes", image: UIImage(systemName: "heart"), tag: 1)
        
        let settingsVC = UINavigationController(rootViewController: SettingViewController(navigationTitle: "설정정", showSaveButton: true))
        settingsVC.tabBarItem = UITabBarItem(title: "Settings", image: UIImage(systemName: "gearshape"), tag: 2)
        
        viewControllers = [homeVC, likeVC, settingsVC]
        
        tabBar.tintColor = .white
        tabBar.unselectedItemTintColor = .gray
        tabBar.backgroundColor = .green
    }
}
