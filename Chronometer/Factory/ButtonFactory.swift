//
//  ButtonFactory.swift
//  Chronometer
//
//  Created by Bruno Lorenzo on 7/8/20.
//  Copyright © 2020 Bruno Lorenzo. All rights reserved.
//

import UIKit

extension UIButton {
    
    static func startButton() -> UIButton {
        let button = UIButton()
        button.clipsToBounds = true
        button.layer.cornerRadius = 20
        button.backgroundColor = .buttonColor
        button.tintColor = .white
        button.setTitle("Start", for: .normal)
        button.titleLabel?.font = .boldSystemFont(ofSize: 21)
        button.isHidden = false
        return button
    }
}
