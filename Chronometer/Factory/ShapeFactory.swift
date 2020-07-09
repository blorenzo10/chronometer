//
//  ShapeFactory.swift
//  Chronometer
//
//  Created by Bruno Lorenzo on 7/8/20.
//  Copyright © 2020 Bruno Lorenzo. All rights reserved.
//

import UIKit

extension CAShapeLayer {
    
    static func createLayer(width: CGFloat, strokeColor: UIColor, fillColor: UIColor, lineCap: CAShapeLayerLineCap, opacity: Float = 1.0) -> CAShapeLayer {
        let layer = CAShapeLayer()
        layer.lineWidth = width
        layer.strokeColor = strokeColor.cgColor
        layer.fillColor = fillColor.cgColor
        layer.opacity = opacity
        layer.lineCap = lineCap
        return layer
    }
}
