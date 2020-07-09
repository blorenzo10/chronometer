//
//  ChronometerView.swift
//  Chronometer
//
//  Created by Bruno Lorenzo on 2/5/20.
//  Copyright © 2020 Bruno Lorenzo. All rights reserved.
//

import UIKit

class ChronometerView: UIView {
    
    // MARK: - Custom Views
    
    private lazy var remainingTimeLabel = UILabel.countDownTimer()
    private lazy var pulseLayer = CAShapeLayer.createLayer(width: 10, strokeColor: .clear, fillColor: .progressColor, lineCap: .round, opacity: 0.8)
    private lazy var backgroundLayer = CAShapeLayer.createLayer(width: 10, strokeColor: .progressColor, fillColor: .black, lineCap: .round)
    private lazy var progressLayer = CAShapeLayer.createLayer(width: 10, strokeColor: .progressColor, fillColor: .clear, lineCap: .round)
    
//    private lazy var remainingTimeLabel: UILabel = {
//        let label = UILabel()
//        label.textColor = .white
//        label.font = .countDownTimerFont
//        label.textAlignment = .center
//        label.text = "10"
//        return label
//    }()
    
//    private lazy var pulseLayer: CAShapeLayer = {
//        let layer = CAShapeLayer()
//        layer.lineWidth = 10
//        layer.strokeColor = UIColor.clear.cgColor
//        layer.fillColor = UIColor.progressColor.cgColor
//        layer.opacity = 0.8
//        layer.lineCap = .round
//        layer.frame = bounds
//        return layer
//    }()
//
//    private lazy var backgroundLayer: CAShapeLayer = {
//        let layer = CAShapeLayer()
//        layer.lineWidth = 10
//        layer.strokeColor = UIColor.backgroundProgressColor.cgColor
//        layer.fillColor = UIColor.black.cgColor
//        layer.lineCap = .round
//        layer.strokeEnd = 1
//        layer.frame = bounds
//        return layer
//    }()
//
//    private lazy var progressLayer: CAShapeLayer = {
//        let layer = CAShapeLayer()
//        layer.lineWidth = 10
//        layer.strokeColor = UIColor.progressColor.cgColor
//        layer.fillColor = UIColor.clear.cgColor
//        layer.lineCap = .round
//        layer.strokeEnd = 0
//        layer.frame = bounds
//        return layer
//    }()
    
    // MARK: - Properties
    
    private var timer = Timer()
    private var duration = 5.0
    private var remainingTime = 0.0
    var animationFinish: (() -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        loadLayers()
    }
}

// MARK: - Setups

extension ChronometerView {
    
    private func commonInit() {
        remainingTimeLabel.text = "10"
    }

    private func loadLayers() {
        
        let arcCenterPoint = CGPoint(x: frame.width/2, y: frame.height/2)
        let circularPath = UIBezierPath(arcCenter: arcCenterPoint, radius: bounds.width / 2, startAngle: -CGFloat.pi / 2, endAngle: 2 * CGFloat.pi - CGFloat.pi/2, clockwise: true).cgPath
        
        pulseLayer.frame = bounds
        
        backgroundLayer.strokeEnd = 1
        backgroundLayer.frame = bounds
        
        progressLayer.strokeEnd = 0
        progressLayer.frame = bounds
        
        pulseLayer.path = circularPath
        layer.addSublayer(pulseLayer)
        
        backgroundLayer.path = circularPath
        layer.addSublayer(backgroundLayer)
        
        progressLayer.path = circularPath
        layer.addSublayer(progressLayer)
        
        setupRemainingTimeLabel()
    }
    
    private func setupRemainingTimeLabel() {
        addSubview(remainingTimeLabel)
        remainingTimeLabel.centerView(in: self)
        remainingTimeLabel.setSize(width: 120, height: 100)
    }
}

// MARK: - Public functions

extension ChronometerView {
    public func startProgress(withDuration duration: Double) {
        self.duration = duration
        remainingTime = duration
        timer.invalidate()
        timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(timerHandler), userInfo: nil, repeats: true)
        
        startAnimations()
    }
}

// MARK: - CABasicAnimation Delegate

extension ChronometerView: CAAnimationDelegate {
    
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        if flag {
            remainingTimeLabel.text = "10"
            pulseLayer.removeAllAnimations()
            animationFinish?()
        }
        timer.invalidate()
    }
}

// MARK: - Handlers

extension ChronometerView {
    
    @objc
    private func timerHandler() {
        remainingTime -= 0.1
        if remainingTime <= 0 {
            remainingTime = 0
            timer.invalidate()
        }
        
        DispatchQueue.main.async {
            self.remainingTimeLabel.text = "\(String.init(format: "%.1f", self.remainingTime))"
        }
    }
}

// MARK: - Animations

extension ChronometerView {
    
    private func startAnimations() {
        animateProgress()
        animatePulse()
    }
    
    private func animateProgress() {
        let progressAnimation = CABasicAnimation(keyPath: #keyPath(CAShapeLayer.strokeEnd))
        progressAnimation.fromValue = 0
        progressAnimation.toValue = 1
        progressAnimation.duration = CFTimeInterval(duration)
        progressAnimation.fillMode = .forwards
        progressAnimation.isRemovedOnCompletion = false
        progressAnimation.delegate = self
        progressLayer.add(progressAnimation, forKey: "progressAnimation")
    }
    
    private func animatePulse() {
        
        let pulseAnimation = CABasicAnimation(keyPath: "transform.scale")
        pulseAnimation.toValue = 1.2
        pulseAnimation.duration = 0.6
        pulseAnimation.repeatCount = Float.infinity
        pulseAnimation.timingFunction = CAMediaTimingFunction(name: .easeOut)
        pulseAnimation.autoreverses = true
        
        pulseLayer.add(pulseAnimation, forKey: "pulseAnimation")
    }
}
