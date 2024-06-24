//
//  SettingView+Alert.swift
//  ShoppingMateApp
//
//  Created by 이윤지 on 6/24/24.
//

import UIKit

extension SettingViewController {
    
    func showLogoutAlert() {
        let alert = UIAlertController(title: "탈퇴하기", message: "탈퇴를 하면 데이터가 모두 초기화 됩니다.\n탈퇴 하시겠습니까?", preferredStyle: .alert)
        let confirmAction = UIAlertAction(title: "확인", style: .destructive) { _ in
            self.resetUserDefaults()
        }
        let cancelAction = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        
        alert.addAction(confirmAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    private func resetUserDefaults() {
        // FileManagerHelper의 모든 저장 데이터를 삭제
        FileManagerHelper.shared.deleteAllData()
        
        let defaults = UserDefaults.standard
        let dictionary = defaults.dictionaryRepresentation()
        dictionary.keys.forEach { key in
            defaults.removeObject(forKey: key)
        }
     
        navigateToOnboarding()
    }
    
    private func navigateToOnboarding() {
        let onboardingVC = OnboardingView()
        let navigationController = UINavigationController(rootViewController: onboardingVC)
        if let window = UIApplication.shared.windows.first {
            window.rootViewController = navigationController
            window.makeKeyAndVisible()
            UIView.transition(with: window, duration: 0.5, options: .transitionCrossDissolve, animations: nil, completion: nil)
        }
    }
}

