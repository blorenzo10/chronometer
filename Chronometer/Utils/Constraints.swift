//
//  Constraints.swift
//  Chronometer
//
//  Created by Bruno Lorenzo on 2/2/20.
//  Copyright © 2020 Bruno Lorenzo. All rights reserved.
//

import UIKit

extension UIView {
    
    func centerView(in superView: UIView) {
        if translatesAutoresizingMaskIntoConstraints {
            translatesAutoresizingMaskIntoConstraints = false
        }
        
        centerXAnchor.constraint(equalTo: superView.centerXAnchor).isActive = true
        centerYAnchor.constraint(equalTo: superView.centerYAnchor).isActive = true
    }
    
    func setSize(width: CGFloat, height: CGFloat) {
        if translatesAutoresizingMaskIntoConstraints {
            translatesAutoresizingMaskIntoConstraints = false
        }
        
        widthAnchor.constraint(equalToConstant: width).isActive = true
        heightAnchor.constraint(equalToConstant: height).isActive = true
    }
}
