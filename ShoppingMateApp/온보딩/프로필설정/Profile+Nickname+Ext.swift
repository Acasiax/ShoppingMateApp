//
//  Profile+Nickname+Ext.swift
//  ShoppingMateApp
//
//  Created by 이윤지 on 6/24/24.
//

import UIKit

extension ProfileSettingViewController {
    func handleNicknameValidationAndSave() {
        let nickname = nicknameTextField.text ?? ""
        let validationMessage = evaluateNickname(nickname: nickname)
        
        if validationMessage == "사용할 수 있는 닉네임이에요" {
            saveUserData { success in
                if success {
                    self.navigateToNextScreen()
                } else {
                    print("데이터 저장에 실패했어요")
                }
            }
        } else {
            AlertHelperProfileSettingView.showErrorAlert(on: self, message: validationMessage)
        }
    }

    func saveUserData(completion: @escaping (Bool) -> Void) {
        let nickname = nicknameTextField.text ?? ""

        // 닉네임이 빈 문자열인지 확인
        if nickname.isEmpty {
            print("⚠️⚠️ 닉네임이 빈 문자열이어서 저장하지 않습니다.")
            completion(false)
            return
        }

        let profileImageData = profileImageView.imageView.image?.pngData()
        let defaults = UserDefaults.standard
        
        // 데이터 저장
        defaults.set(nickname, forKey: "UserNickname")

        if let profileImageData = profileImageData {
            defaults.set(profileImageData, forKey: "UserProfileImage")
        }

        if let randomImageName = profileImageView.imageView.accessibilityIdentifier {
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
            self.printUserDefaults()  // 현재 상태 출력
        }
    }

    func printUserDefaults() {
        DispatchQueue.main.async {
            let defaults = UserDefaults.standard
            
            if let nickname = defaults.string(forKey: "UserNickname") {
                print("닉네임: \(nickname)")
            } else {
                print("닉네임: 없음")
            }

            if let profileImageData = defaults.data(forKey: "UserProfileImage") {
                print("프로필 이미지 데이터: \(profileImageData.count) 바이트")
            } else {
                print("프로필 이미지 데이터: 없음")
            }

            if let profileImageName = defaults.string(forKey: "UserProfileImageName") {
                print("프로필 이미지 이름: \(profileImageName)")
            } else {
                print("프로필 이미지 이름: 없음")
            }

            if let joinDate = defaults.string(forKey: "UserJoinDate") {
                print("가입 날짜: \(joinDate)")
            } else {
                print("가입 날짜: 없음")
            }

            let isNicknameSet = defaults.bool(forKey: "isNicknameSet")
            print("닉네임 설정 여부: \(isNicknameSet)")
        }
    }
    
    //🕵🏻‍♂️🔍
    func loadUserData() {
        let defaults = UserDefaults.standard
        if let nickname = defaults.string(forKey: "UserNickname") {
            nicknameTextField.text = nickname
            print("유저디폴트에 닉네임 기록이 있네요: \(nickname)")
        } else {
            print("유저디폴트에 닉네임 기록이 없습니다. 처음 실행하나봐요")
        }
        
        if let profileImageData = defaults.data(forKey: "UserProfileImage"), let profileImage = UIImage(data: profileImageData) {
            profileImageView.imageView.image = profileImage
        } else {
            let profileImages = ["profile_0", "profile_1", "profile_2", "profile_3", "profile_4", "profile_5", "profile_6", "profile_7", "profile_8", "profile_9", "profile_10", "profile_11"]
            let randomImageName = profileImages.randomElement() ?? "profile_0"
            profileImageView.imageView.image = UIImage(named: randomImageName)
            profileImageView.imageView.accessibilityIdentifier = randomImageName
            UserDefaults.standard.set(randomImageName, forKey: "UserProfileImageName")
        }
        currentProfileImageName = defaults.string(forKey: "UserProfileImageName")
        printUserDefaults()
    }

    func isValidNickname(nickname: String) -> Bool {
        let nicknameRegex = "^[가-힣a-zA-Z]{2,10}$"
        let predicate = NSPredicate(format: "SELF MATCHES %@", nicknameRegex)
        return predicate.evaluate(with: nickname)
    }
    
    func evaluateNickname(nickname: String) -> String {
        if nickname.count < 2 || nickname.count >= 10 {
            return "2글자 이상 10글자 미만으로 설정해주세요"
        }
        if nickname.rangeOfCharacter(from: CharacterSet.decimalDigits) != nil {
            return "닉네임에 숫자는 포함 할 수 없어요"
        }
        if nickname.rangeOfCharacter(from: CharacterSet(charactersIn: "@#$%")) != nil {
            return "닉네임에 @,#,$,% 는 포함할 수 없어요"
        }
        
        return "사용할 수 있는 닉네임이에요"
    }
}

