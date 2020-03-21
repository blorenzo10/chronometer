//
//  TimeSlider.swift
//  Chronometer
//
//  Created by Bruno Lorenzo on 2/25/20.
//  Copyright © 2020 Bruno Lorenzo. All rights reserved.
//

import UIKit

class TimeSlider: UIControl {
    
    // MARK: - Views & Layers
    
    private lazy var circularLayer =  CAShapeLayer()
    private lazy var selectorButton = UIButton(type: .custom)
    private var currentAngle: Float = 90.0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        setupSubViews()
    }
    
    override func beginTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        let point = touch.location(in: self)
        let rect = selectorButton.frame.inset(by: .init(top: -20, left: -20, bottom: -20, right: -20))
        
        return rect.contains(point)
    }
    
    override func continueTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        let point = touch.location(in: self)
        
        let xPosition = point.x - (frame.size.width * 0.5)
        let yPosition = point.y - (frame.size.height * 0.5)
        
        let angle = -Double(atan2(Double(xPosition), Double(yPosition)))
        var degree = radianToDegrees(angle)
        if degree < 0 {
            degree += 360
        }
        currentAngle = Float(degree)
        updateButtonPosition()
        return true
    }
    
    override func endTracking(_ touch: UITouch?, with event: UIEvent?) {
        
    }
}


// MARK: - Setups

extension TimeSlider {
    
    private func setupSubViews() {
        
        setupLayer()
        setupButton()
    }
    
    private func setupLayer() {
        let arcCenterPoint = CGPoint(x: bounds.width/2, y: bounds.height/2)
        let circularPath = UIBezierPath(arcCenter: arcCenterPoint, radius: bounds.width / 2, startAngle: -CGFloat.pi / 2, endAngle: 2 * CGFloat.pi - CGFloat.pi/2, clockwise: true).cgPath

        circularLayer.lineWidth = 10
        circularLayer.strokeColor = UIColor.pulseColor.cgColor
        circularLayer.fillColor = UIColor.clear.cgColor
        circularLayer.opacity = 0.8
        circularLayer.lineCap = .round
        circularLayer.path = circularPath
        
        layer.addSublayer(circularLayer)
    }
    
    private func setupButton() {
        
        selectorButton.frame = CGRect(x: (bounds.width / 2) - 15, y: -15, width: 30, height: 30)
        selectorButton.backgroundColor = .blue
        selectorButton.layer.cornerRadius = selectorButton.frame.size.width/2
        selectorButton.layer.masksToBounds = true
        selectorButton.isUserInteractionEnabled = false
        
        addSubview(selectorButton)
    }
}

// MARK: - Helpers

extension TimeSlider {
    
    private func radianToDegrees(_ radianValue: Double) -> Double {
        return Double(radianValue * (180/Double.pi))
    }
    
    private func degreeToRadian(_ degreeValue: Double) -> Double {
        return Double(degreeValue * (Double.pi/180))
    }
    
    private func updateButtonPosition() {
        
        let angle = degreeToRadian(Double(currentAngle))
        
        let x = cos(angle)
        let y = sin(angle)
        
        var rect = selectorButton.frame
        
        let radius = frame.size.width * 0.5
        let center = CGPoint(x: radius, y: radius)
        let buttonCenter: CGFloat = 15.0
        
        // x = cos(angle) * radius + CenterX;
        //let finalX = (CGFloat(x) * (radius - buttonCenter)) + center.x
        let finalX = (CGFloat(x) * radius) + center.x
        
        // y = sin(angle) * radius + CenterY;
        let finalY = (CGFloat(y) * radius) + center.y
        
        rect.origin.x = finalX - buttonCenter
        rect.origin.y = finalY - buttonCenter
        
        selectorButton.frame = rect
    }
}
