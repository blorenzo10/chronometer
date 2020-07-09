//
//  ColorFactory.swift
//  Chronometer
//
//  Created by Bruno Lorenzo on 7/8/20.
//  Copyright © 2020 Bruno Lorenzo. All rights reserved.
//

import UIKit

extension CGColor {
    
    static func createGradientColors() -> [[CGColor]] {
        var colors: [[CGColor]] = []
        
        let colorOne = #colorLiteral(red: 0, green: 0.6155423522, blue: 0.9723593593, alpha: 1).cgColor
        let colorTwo = #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1).cgColor
        let colorThree = #colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1).cgColor
        
        colors.append([colorOne, colorTwo])
        colors.append([colorTwo, colorThree])
        colors.append([colorThree, colorOne])
        colors.append([colorOne, colorThree])
        
        return colors
    }
}
