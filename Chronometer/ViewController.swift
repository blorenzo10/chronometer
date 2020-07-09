//
//  ViewController.swift
//  Chronometer
//
//  Created by Bruno Lorenzo on 2/1/20.
//  Copyright © 2020 Bruno Lorenzo. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    // MARK: - Custom Layers & Views
    
    private lazy var gradientLayer = CAGradientLayer.backgroundGradient(withColor: gradientColors[currentGradient], bounds: view.bounds)
    private lazy var startCountDownButton = UIButton.startButton()
    private lazy var countDownLabel = UILabel.countDownSteps()
    private lazy var setupTimeLayer = CAShapeLayer.createLayer(width: 10, strokeColor: .clear, fillColor: .progressColor, lineCap: .round, opacity: 0.8)
    private lazy var countDownView = ChronometerView()
    
    // MARK: - Properties
    
    private let animationId = "ID"
    private let gradientAnimationId = "GradientAnimation"
    private let scaleAnimationId = "ScaleAnimation"
    private let countDownTexts = ["Ready?", "3", "2", "1", "Go!"]
    private var gradientColors = CGColor.createGradientColors()
    private var currentGradient = 0
    
    private var currentCountDownStep = -1 {
        didSet {
            if currentCountDownStep > -1 {
                if currentCountDownStep < countDownTexts.count {
                    countDownLabel.text = countDownTexts[currentCountDownStep]
                    animateCountDownLabel()
                } else {
                    countDownLabel.isHidden = true
                    countDownView.isHidden = false
                    animateCountDownViewIn()
                }
            }
        }
    }
    
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setupUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        countDownView.isHidden = true
    }
}

// MARK: - Animation Delegate

extension ViewController: CAAnimationDelegate {
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
    
        guard let animationId = anim.value(forKey: animationId) as? String else { return }
        
        if flag {
            if animationId == gradientAnimationId {
                gradientLayer.colors = gradientColors[currentGradient]
                animateGradient()
            } else if animationId == scaleAnimationId {
                currentCountDownStep += 1
            }
        }
    }
}

// MARK: - Setups

extension ViewController {
    
    private func setupUI() {
        setupGradientLayer()
        setupCountDownView()
        setupStartButton()
        setupCountDownLabel()
    }
    
    private func setupGradientLayer() {
        view.layer.insertSublayer(gradientLayer, at: 0)
        animateGradient()
    }
    
    private func setupCountDownView() {
        view.addSubview(countDownView)
        countDownView.centerView(in: view)
        countDownView.setSize(width: 200, height: 200)
        countDownView.animationFinish = {
            
            self.startCountDownButton.isHidden = false
            self.startCountDownButton.alpha = 1
            self.startCountDownButton.transform = .identity
            
            UIView.transition(from: self.countDownView, to: self.startCountDownButton, duration: 1, options: [.transitionCrossDissolve, .showHideTransitionViews], completion: { _ in
                self.currentCountDownStep = -1
            })
        }
    }
    
    private func setupStartButton() {
        startCountDownButton.addTarget(self, action: #selector(startButtonDidTap(_:)), for: .touchUpInside)
        view.addSubview(startCountDownButton)
        startCountDownButton.centerView(in: view)
        startCountDownButton.setSize(width: 150, height: 50)
    }
    
    private func setupCountDownLabel() {
        view.addSubview(countDownLabel)
        countDownLabel.centerView(in: view)
        countDownLabel.setSize(width: 250, height: 50)
        countDownLabel.isHidden = true
    }
}

// MARK: - Animations

extension ViewController {
    
    private func animateGradient() {
        currentGradient = currentGradient < gradientColors.count - 1 ? currentGradient + 1 : 0
        
        let gradientAnimation = CABasicAnimation(keyPath: #keyPath(CAGradientLayer.colors))
        gradientAnimation.duration = 3.0
        gradientAnimation.toValue = gradientColors[currentGradient]
        gradientAnimation.fillMode = .forwards
        gradientAnimation.isRemovedOnCompletion = false
        gradientAnimation.delegate = self
        gradientAnimation.setValue(gradientAnimationId, forKey: animationId)
        gradientLayer.add(gradientAnimation, forKey: "gradientChangeAnimation")
    }
}

// MARK: - Action Handlers

extension ViewController {
    
    @objc
    private func startButtonDidTap(_ sender: UIButton) {
        animateButtonOut()
    }
}

// MARK: - Animations

extension ViewController {
    
    private func animateButtonOut() {
        let buttonTranslationTransform = CGAffineTransform(translationX: 0, y: 100)
        
        UIView.animate(withDuration: 0.5, animations: {
            self.startCountDownButton.transform = buttonTranslationTransform
            self.startCountDownButton.alpha = 0
        }, completion: { complete in
            if complete {
                self.startCountDownButton.transform = CGAffineTransform(translationX: 0, y: 200)
                self.currentCountDownStep += 1
            }
        })
    }
    
    private func animateCountDownLabel() {
        countDownLabel.isHidden = false
        
        setupOpacityAnimation()
        setupScaleAnimation()
    }
    
    private func setupOpacityAnimation() {
        let opacityAnimation = CABasicAnimation(keyPath: #keyPath(CALayer.opacity))
        opacityAnimation.toValue = 0
        opacityAnimation.duration = 0.5
        opacityAnimation.beginTime = CACurrentMediaTime() + 0.5
        countDownLabel.layer.add(opacityAnimation, forKey: "OpacityCountDownAnimation")
    }
    
    private func setupScaleAnimation() {
        let scaleAnimation = CABasicAnimation(keyPath: "transform.scale")
        scaleAnimation.toValue = 6
        scaleAnimation.duration = 1
        scaleAnimation.timingFunction = CAMediaTimingFunction(controlPoints: 0.11, 0.9, 0.92, 0.13)
        scaleAnimation.isRemovedOnCompletion = true
        scaleAnimation.delegate = self
        scaleAnimation.setValue(scaleAnimationId, forKey: animationId)
        countDownLabel.layer.add(scaleAnimation, forKey: "ScaleCountDownAnimation")
    }
    
    private func animateCountDownViewIn() {
        countDownView.alpha = 0
        
        UIView.animate(withDuration: 0.6, animations: {
            self.countDownView.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
            self.countDownView.alpha = 1
            
        }) { _ in
            UIView.animate(withDuration: 0.3, animations: {
                self.countDownView.transform = .identity
                self.countDownView.startProgress(withDuration: 10)
            })
        }
    }
}
