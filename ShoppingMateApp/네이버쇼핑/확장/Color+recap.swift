//
//  Color+recap.swift
//  ShoppingMateApp
//
//  Created by 이윤지 on 6/17/24.
//

import UIKit

extension UIColor {
    static let customOrange = UIColor(hex: "#EF8947")
    static let customBlack = UIColor(hex: "#000000")
    static let customGray1 = UIColor(hex: "#828282")
    //버튼 색상 토글할 떄
    static let customGray2 = UIColor(hex: "#4C4C4C")
    static let customLightGray = UIColor(hex: "#CDCDCD")
    static let customWhite = UIColor(hex: "#FFFFFF")
    
    var cgColorValue: CGColor {
        return self.cgColor
    }

    convenience init(hex: String) {
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")
        
        var rgb: UInt64 = 0
        Scanner(string: hexSanitized).scanHexInt64(&rgb)
        
        let red = CGFloat((rgb & 0xFF0000) >> 16) / 255.0
        let green = CGFloat((rgb & 0x00FF00) >> 8) / 255.0
        let blue = CGFloat(rgb & 0x0000FF) / 255.0
        
        self.init(red: red, green: green, blue: blue, alpha: 1.0)
    }
}


