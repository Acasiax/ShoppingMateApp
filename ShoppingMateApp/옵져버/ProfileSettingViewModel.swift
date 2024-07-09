//
//  ProfileSettingViewModel.swift
//  ShoppingMateApp
//
//  Created by 이윤지 on 7/9/24.
//

import Foundation
import UIKit

class ProfileSettingViewModel {
    var inputNickname: Observable<String?> = Observable(nil)
    var outputValidationMessage = Observable("")
    var outputIsValidNickname = Observable(false)
    
    init() {
        inputNickname.bind { [weak self] nickname in
            self?.validateNickname(nickname: nickname)
        }
    }
    
    private func validateNickname(nickname: String?) {
        guard let nickname = nickname else {
            outputValidationMessage.value = "닉네임을 입력해주세요."
            outputIsValidNickname.value = false
            return
        }
        
        if nickname.count < 2 || nickname.count >= 10 {
            outputValidationMessage.value = "2글자 이상 10글자 미만으로 설정해주세요"
            outputIsValidNickname.value = false
        } else if nickname.rangeOfCharacter(from: CharacterSet.decimalDigits) != nil {
            outputValidationMessage.value = "닉네임에 숫자는 포함 할 수 없어요"
            outputIsValidNickname.value = false
        } else if nickname.rangeOfCharacter(from: CharacterSet(charactersIn: "@#$%")) != nil {
            outputValidationMessage.value = "닉네임에 @,#,$,% 는 포함할 수 없어요"
            outputIsValidNickname.value = false
        } else {
            outputValidationMessage.value = "사용할 수 있는 닉네임이에요"
            outputIsValidNickname.value = true
        }
    }
    
    func saveUserData(nickname: String, profileImage: UIImage?, completion: @escaping (Bool) -> Void) {
        // 닉네임이 빈 문자열인지 확인
        if nickname.isEmpty {
            print("⚠️⚠️ 닉네임이 빈 문자열이어서 저장하지 않습니다.")
            completion(false)
            return
        }

        let profileImageData = profileImage?.pngData()
        let defaults = UserDefaults.standard
        
        // 데이터 저장
        defaults.set(nickname, forKey: "UserNickname")

        if let profileImageData = profileImageData {
            defaults.set(profileImageData, forKey: "UserProfileImage")
        }

        if let randomImageName = profileImage?.accessibilityIdentifier {
            defaults.set(randomImageName, forKey: "UserProfileImageName")
        }

        if defaults.string(forKey: "UserJoinDate") == nil {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            let joinDate = dateFormatter.string(from: Date())
            defaults.set(joinDate, forKey: "UserJoinDate")
        }

        // 닉네임 설정 여부 저장
        defaults.set(true, forKey: "isNicknameSet")

        // 저장된 값 확인
        DispatchQueue.main.async {
            if let savedNickname = defaults.string(forKey: "UserNickname") {
                print("💡: \(savedNickname)")
                completion(true)
            } else {
                print("⚠️⚠️ 닉네임을 유저디폴트에 저장하지 못했습니다!")
                completion(false)
            }
        }
    }
}
