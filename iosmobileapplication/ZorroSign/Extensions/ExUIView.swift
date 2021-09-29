//
//  ExUIView.swift
//  ZorroSign
//
//  Created by CHATHURA ELLAWALA on 10/13/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import UIKit

extension UIView {
    func roundCorners(cornerRadius: Double) {
        self.layer.cornerRadius = CGFloat(cornerRadius)
        self.clipsToBounds = true
        self.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMaxXMaxYCorner, .layerMinXMaxYCorner]
    }
}

// MARK: - Animations

extension UIView {

    func fadeIn(withDuration: Double = 0.5) {
        UIView.animate(withDuration: withDuration, delay: 0.0, options: UIView.AnimationOptions.curveEaseIn, animations: {
            self.alpha = 1.0
        }, completion: nil)
    }
    
    func fadeOut(withDuration: Double = 0.3) {
        UIView.animate(withDuration: withDuration, delay: 0.0, options: UIView.AnimationOptions.curveEaseOut, animations: {
            self.alpha = 0.0
        }, completion: nil)
    }
    
    func addBorderWithCornerRadius(color: UIColor) -> CALayer {
        let borderLayer = CAShapeLayer()
        borderLayer.strokeColor = color.cgColor
        borderLayer.lineDashPattern = [7, 3]
        borderLayer.frame = bounds
        borderLayer.fillColor = nil
        borderLayer.path = UIBezierPath(roundedRect: bounds, byRoundingCorners: .allCorners, cornerRadii: CGSize(width: 5, height: 5)).cgPath
        
        layer.addSublayer(borderLayer)
        return borderLayer
    }
}
