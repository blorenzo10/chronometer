//
//  Fonts.swift
//  Chronometer
//
//  Created by Bruno Lorenzo on 2/5/20.
//  Copyright © 2020 Bruno Lorenzo. All rights reserved.
//

import Foundation
import UIKit

struct CustomFontNames {
    static let oswaldBold = "Oswald-Bold"
    static let owsaldRegular = "Oswald-Regular"
}

extension UIFont {
    
    static func customFont(name: String, size: CGFloat) -> UIFont {
        return UIFont(name: name, size: size) ?? UIFont.systemFont(ofSize: size)
    }
}

