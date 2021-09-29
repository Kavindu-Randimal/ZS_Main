//
//  AppButton.swift
//  ZorroSign
//
//  Created by Apple on 09/10/18.
//  Copyright © 2018 Apple. All rights reserved.
//

import UIKit

@IBDesignable
class AppButton: UIButton {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    @IBInspectable var bgColor: UIColor? = UIColor.white {
        didSet {
            backgroundColor = bgColor
        }
    }
    @IBInspectable var txtColor: UIColor? = UIColor.blue {
        didSet {
            setTitleColor(txtColor, for: UIControl.State.normal)
        }
    }
    @IBInspectable var borderColor: UIColor? = UIColor.blue {
        didSet {
            layer.borderColor = borderColor?.cgColor
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = 5
        layer.borderWidth = 1.0
        self.clipsToBounds = true
    }
}
