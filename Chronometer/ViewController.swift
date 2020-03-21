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
    
    private lazy var gradientLayer: CAGradientLayer = {
        let gradient = CAGradientLayer()
        
        gradient.frame = view.bounds
        gradient.colors = gradientColors[currentGradient]
        gradient.startPoint = CGPoint(x:0, y:0)
        gradient.endPoint = CGPoint(x:1, y:1)
        gradient.drawsAsynchronously = true
        
        return gradient
    }()
    
    private lazy var startCountDownButton: UIButton = {
        let button = UIButton()
        button.clipsToBounds = true
        button.layer.cornerRadius = 20
        button.backgroundColor = .buttonColor
        button.tintColor = .white
        button.setTitle("Start", for: .normal)
        button.titleLabel?.font = .boldSystemFont(ofSize: 21)
        button.addTarget(self, action: #selector(startButtonDidTap(_:)), for: .touchUpInside)
        button.isHidden = false
        return button
    }()
    
    private lazy var countDownLabel: UILabel = {
        let label = UILabel()
        label.text = countDownTexts[0]
        label.font = .customFont(name: CustomFontNames.oswaldBold, size: 22)
        label.textColor = .black
        label.textAlignment = .center
        return label
    }()
    
    private lazy var setupTimeLayer: CAShapeLayer = {
        let layer = CAShapeLayer()
        layer.lineWidth = 10
        layer.strokeColor = UIColor.clear.cgColor
        layer.fillColor = UIColor.progressColor.cgColor
        layer.opacity = 0.8
        layer.lineCap = .round
        return layer
    }()
    
    private lazy var countDownTimerView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()
    
    
    private lazy var countDownView = ChronometerView()
    private var gradientAnimation: CABasicAnimation!
    private var scaleAnimation: CABasicAnimation = {
        let timingFunction = CAMediaTimingFunction(controlPoints: 0.11, 0.9, 0.92, 0.13)
        
        let animation = CABasicAnimation(keyPath: "transform.scale")
        animation.toValue = 6
        animation.duration = 1
        animation.timingFunction = timingFunction
        animation.isRemovedOnCompletion = true
        animation.setValue("scaleLabel", forKey: "id")
        return animation
    }()
    
    // MARK: - Properties
    
    private var gradientColors: [[CGColor]] = {
        var colors: [[CGColor]] = []
        
        let colorOne = #colorLiteral(red: 0, green: 0.6155423522, blue: 0.9723593593, alpha: 1).cgColor
        let colorTwo = #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1).cgColor
        let colorThree = #colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1).cgColor
        
        colors.append([colorOne, colorTwo])
        colors.append([colorTwo, colorThree])
        colors.append([colorThree, colorOne])
        colors.append([colorOne, colorThree])
        
        return colors
    }()
    
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
    private let countDownTexts = ["Ready?", "3", "2", "1", "Go!"]
    
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
        
    
        guard let animationName = anim.value(forKey: "id") as? String else { return }
        
        if flag {
            if animationName == "gradientAnimation" {
                gradientLayer.colors = gradientColors[currentGradient]
                animateGradient()
            } else if animationName == "scaleLabel" {
                currentCountDownStep += 1
            }
        }
    }
}

// MARK: - Setups

extension ViewController {
    
    private func setupUI() {
        setupGradientLayer()
        setupTimerView()
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
    
    private func setupTimerView() {
        view.addSubview(countDownTimerView)
        countDownTimerView.centerView(in: view)
        countDownTimerView.setSize(width: 200, height: 200)
    }
    
    private func setupStartButton() {
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
        
        gradientAnimation = CABasicAnimation(keyPath: "colors")
        gradientAnimation.duration = 3.0
        gradientAnimation.toValue = gradientColors[currentGradient]
        gradientAnimation.fillMode = .forwards
        gradientAnimation.isRemovedOnCompletion = false
        gradientAnimation.delegate = self
        gradientAnimation.setValue("gradientAnimation", forKey: "id")
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
    
        scaleAnimation.delegate = self
        countDownLabel.layer.add(scaleAnimation, forKey: "ScaleCountDownAnimation")
        
        let opacityAnimation = CABasicAnimation(keyPath: "opacity")
        opacityAnimation.toValue = 0
        opacityAnimation.duration = 0.5
        opacityAnimation.beginTime = CACurrentMediaTime() + 0.5
        countDownLabel.layer.add(opacityAnimation, forKey: "OpacityCountDownAnimation")
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
