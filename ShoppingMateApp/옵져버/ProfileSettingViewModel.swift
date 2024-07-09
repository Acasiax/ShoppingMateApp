//
//  ProfileSettingViewModel.swift
//  ShoppingMateApp
//
//  Created by 이윤지 on 7/9/24.
//

import Foundation

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
}
