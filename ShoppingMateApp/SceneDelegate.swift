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
        let defaults = UserDefaults.standard
        let isNicknameSet = defaults.bool(forKey: "isNicknameSet")
        
        
        if isNicknameSet {
                 // 닉네임이 설정된 경우 닉네임을 출력합니다.
                 if let nickname = defaults.string(forKey: "nickname"), !nickname.isEmpty {
                     print("닉네임: \(nickname)")
                 } else {
                     // 닉네임이 없거나 비어있는 경우, isNicknameSet을 false로 재설정합니다.
                     defaults.set(false, forKey: "isNicknameSet")
                     print("닉네임이 설정되지 않았습니다.")
                 }
             }
             
             if defaults.bool(forKey: "isNicknameSet") {
                 let tabBarVC = UITabBarController()
                 let searchNavVC = UINavigationController(rootViewController: HomeViewController())
                 let likeNavVC = UINavigationController(rootViewController: LikeViewController())
                 let yunjiVC = UINavigationController(rootViewController: SettingViewController())
                 
                 searchNavVC.title = "검색"
                 likeNavVC.title = "설정"
                 yunjiVC.title = "아아"
                 
                 tabBarVC.setViewControllers([searchNavVC, likeNavVC, yunjiVC], animated: false)
                 tabBarVC.modalPresentationStyle = .fullScreen
                 tabBarVC.tabBar.backgroundColor = .green
                 tabBarVC.tabBar.tintColor = .white
                 tabBarVC.tabBar.unselectedItemTintColor = .gray
                 
                 guard let items = tabBarVC.tabBar.items else { return }
                 items[0].image = UIImage(systemName: "magnifyingglass")
                 items[1].image = UIImage(systemName: "person")
                 items[2].image = UIImage(systemName: "person")
                 
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
