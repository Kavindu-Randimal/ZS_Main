//
//  CircularImg.swift
//  ZorroSign
//
//  Created by Apple on 08/10/18.
//  Copyright © 2018 Apple. All rights reserved.
//

import UIKit

class CircularImg: UIImageView {

    
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
   /*
    override func draw(_ rect: CGRect) {
        // Drawing code
        
    }
    */
    override func layoutSubviews() {
        super.layoutSubviews()
        let radius = self.frame.width/2.0
        layer.cornerRadius = radius
        self.clipsToBounds = true
    }

}
