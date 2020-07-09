//
//  Gradient.swift
//  Chronometer
//
//  Created by Bruno Lorenzo on 7/8/20.
//  Copyright © 2020 Bruno Lorenzo. All rights reserved.
//

import UIKit

extension CAGradientLayer {
    
    static func backgroundGradient(withColor colors: [CGColor], bounds: CGRect) -> CAGradientLayer {
        let gradient = CAGradientLayer()
        
        gradient.frame = bounds
        gradient.colors = colors
        gradient.startPoint = CGPoint(x:0, y:0)
        gradient.endPoint = CGPoint(x:1, y:1)
        gradient.drawsAsynchronously = true
        
        return gradient
    }
}
