//
//  CustomButton.swift
//  ZorroSign
//
//  Created by Apple on 25/08/18.
//  Copyright © 2018 Apple. All rights reserved.
//

import UIKit

class CustomButton: UIButton {

    
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
        
        self.layer.borderWidth = 1.0
        //self.layer.borderColor = 
        self.layer.cornerRadius = 5
        self.clipsToBounds = true
    }
    

}
