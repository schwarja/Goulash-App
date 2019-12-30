//
//  UIView+Gradients.swift
//  GoulashClub
//
//  Created by Jan Schwarz on 30/12/2019.
//  Copyright © 2019 Jan Schwarz. All rights reserved.
//

import UIKit

extension UIView {
    enum GradientDirection {
        case topToBottom
        case bottomToTop
    }
    
    @discardableResult
    func addGradientMaskLayer(withFrame frame: CGRect, withDirection direction: GradientDirection = .topToBottom, startColor: UIColor = UIColor(white: 0, alpha: 1), endColor: UIColor = UIColor(white: 0, alpha: 0)) -> CALayer {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [startColor.cgColor, endColor.cgColor]
        
        switch direction {
        case .topToBottom:
            gradientLayer.startPoint = CGPoint(x: 0, y: 0)
            gradientLayer.endPoint = CGPoint(x: 0, y: 1)
            
        case .bottomToTop:
            gradientLayer.startPoint = CGPoint(x: 0, y: 1)
            gradientLayer.endPoint = CGPoint(x: 0, y: 0)
        }
        
        gradientLayer.frame = frame
        
        layer.insertSublayer(gradientLayer, at: 0)
        
        return gradientLayer
    }
}
