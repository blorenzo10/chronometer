//
//  LabelFactory.swift
//  Chronometer
//
//  Created by Bruno Lorenzo on 7/8/20.
//  Copyright © 2020 Bruno Lorenzo. All rights reserved.
//

import UIKit

extension UILabel {
    
    static func countDownSteps() -> UILabel {
        let label = UILabel()
        label.font = .countDownLabelFont
        label.textColor = .black
        label.textAlignment = .center
        return label
    }
    
    static func countDownTimer() -> UILabel {
        let label = UILabel()
        label.textColor = .white
        label.font = .countDownTimerFont
        label.textAlignment = .center
        return label
    }
}
