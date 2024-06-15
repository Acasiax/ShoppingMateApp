//
//  SceneDelegate.swift
//  ShoppingMateApp
//
//  Created by 이윤지 on 6/14/24.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        window = UIWindow(windowScene: windowScene)
        let initialViewController: UIViewController
        
        let isNicknameSet = UserDefaults.standard.bool(forKey: "isNicknameSet")
        if isNicknameSet {
            let tabBarVC = UITabBarController()
            let searchNavVC = UINavigationController(rootViewController: HomeViewController())
            let likeNavVC = UINavigationController(rootViewController: LikeViewController())
            
            searchNavVC.title = "검색"
            likeNavVC.title = "설정"
            
            tabBarVC.setViewControllers([searchNavVC, likeNavVC], animated: false)
            tabBarVC.modalPresentationStyle = .fullScreen
            tabBarVC.tabBar.backgroundColor = .green
            tabBarVC.tabBar.tintColor = .white
            tabBarVC.tabBar.unselectedItemTintColor = .gray
            
            guard let items = tabBarVC.tabBar.items else { return }
            items[0].image = UIImage(systemName: "magnifyingglass")
            items[1].image = UIImage(systemName: "person")
            
            initialViewController = tabBarVC
        } else {
            let navigationController = UINavigationController(rootViewController: OnboardingView())
            initialViewController = navigationController
        }
        
        window?.rootViewController = initialViewController
        window?.makeKeyAndVisible()
    }
    
    
    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }
    
    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }
    
    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }
    
    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }
    
    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }
    
    
}
