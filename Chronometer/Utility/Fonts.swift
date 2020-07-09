//
//  Fonts.swift
//  Chronometer
//
//  Created by Bruno Lorenzo on 2/5/20.
//  Copyright © 2020 Bruno Lorenzo. All rights reserved.
//

import Foundation
import UIKit

enum CustomFontType: String {
    case regular = "Oswald-Regular"
    case bold = "Oswald-Bold"
}

extension UIFont {

    static func customFont(type: CustomFontType, size: CGFloat) -> UIFont {
        return UIFont(name: type.rawValue, size: size) ?? UIFont.systemFont(ofSize: size)
    }
    
    static let countDownLabelFont: UIFont = {
        return customFont(type: .bold, size: 22)
    }()
    
    static let countDownTimerFont: UIFont = {
        return customFont(type: .regular, size: 70)
    }()
}

