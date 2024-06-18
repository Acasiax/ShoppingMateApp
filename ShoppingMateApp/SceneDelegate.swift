//
//  SceneDelegate.swift
//  ShoppingMateApp
//
//  Created by 이윤지 on 6/14/24.
//    // defaults.set(false, forKey: "isNicknameSet") //📍

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        window = UIWindow(windowScene: windowScene)
        let initialViewController: UIViewController
        let defaults = UserDefaults.standard

        // UserDefaults 값 가져오기
        let nickname = defaults.string(forKey: "UserNickname") ?? "닉네임이 설정되지 않음"
        let profileImageName = defaults.string(forKey: "UserProfileImage") ?? "프로필 이미지가 설정되지 않음"
        let joinDate = defaults.string(forKey: "UserJoinDate") ?? "가입 날짜가 설정되지 않음"
        
        // 닉네임이 있는지 확인하고 isNicknameSet 값을 설정
        let isNicknameSet: Bool
        if nickname != "닉네임이 설정되지 않음" && nickname != "" {
            isNicknameSet = true
            defaults.set(true, forKey: "isNicknameSet") // 닉네임이 있으면 true로 설정
        } else {
            isNicknameSet = false
            print("닉네임이 없는데요?")
        }
        
        
        // UserDefaults 값 출력
        print("닉네임🐻🌟: \(nickname)")
        print("프로필 이미지 이름🐻: \(profileImageName)")
        print("isNicknameSet:닉네임이 있을까?!🐻: \(isNicknameSet)")
        print("가입 날짜🐻: \(joinDate)")
        
        // 닉네임이 설정되어 있으면 isNicknameSet의 값은 true
        
        // 초기 뷰 컨트롤러 설정
        if isNicknameSet {
            initialViewController = MainTabBarController()
        } else {
            let navigationController = UINavigationController(rootViewController: OnboardingView())
            initialViewController = navigationController
        }
        
        window?.rootViewController = initialViewController
        window?.makeKeyAndVisible()
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        
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
