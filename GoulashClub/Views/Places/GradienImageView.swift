//
//  GradienImageView.swift
//  GoulashClub
//
//  Created by Jan Schwarz on 30/12/2019.
//  Copyright © 2019 Jan Schwarz. All rights reserved.
//

import UIKit

class GradientImageView: UIImageView {
    private var gradientFraction: CGFloat = 0.5
    private var gradientDirection: UIView.GradientDirection = .bottomToTop
    private var startColor: UIColor = .black
    private var endColor: UIColor = UIColor.black.withAlphaComponent(0)
    private var gradientLayer: CALayer?
    
    init(withDirection direction: UIView.GradientDirection, fraction: CGFloat, startColor: UIColor, endColor: UIColor) {
        self.gradientFraction = fraction
        self.gradientDirection = direction
        self.startColor = startColor
        self.endColor = endColor
        
        super.init(frame: .zero)
        
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        setupUI()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        updateGradient()
    }
    
    func refresh() {
        gradientLayer?.removeFromSuperlayer()
        
        setupUI()
        updateGradient()
    }
    
    private func setupUI() {
        gradientLayer = self.addGradientMaskLayer(withFrame: .zero, withDirection: gradientDirection, startColor: startColor, endColor: endColor)
    }
    
    private func updateGradient() {
        let portion = self.frame.height*gradientFraction

        let frame: CGRect
        switch gradientDirection {
        case .topToBottom:
            frame = CGRect(x: 0, y: 0, width: self.frame.width, height: portion)
        case .bottomToTop:
            frame = CGRect(x: 0, y: self.frame.height - portion, width: self.frame.width, height: portion)
        }
        
        gradientLayer?.frame = frame
    }
}
