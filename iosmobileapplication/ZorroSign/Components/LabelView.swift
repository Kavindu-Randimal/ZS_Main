//
//  LabelView.swift
//  ZorroSign
//
//  Created by Apple on 03/08/18.
//  Copyright © 2018 Apple. All rights reserved.
//

import UIKit

class LabelView: UILabel {

    
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
        self.layer.borderColor = self.borderclr.cgColor
        self.layer.cornerRadius = 4
        self.layer.borderWidth = 1.0
    }
    

    var borderclr: UIColor = UIColor.black
    
    
}

