//
//  CustomTable.swift
//  ZorroSign
//
//  Created by Apple on 13/07/18.
//  Copyright © 2018 Apple. All rights reserved.
//

import UIKit

class CustomTable: UITableView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        print("customtable touches")
        //lastPoint = touches.first?.location(in: self)
        let location: CGPoint = (touches.first?.location(in: self))!
        let v: UIView = self.hitTest(location, with: nil) ?? UIView()
        print("view tag: \(v.tag)")
        
        if v.tag == 143 || v.tag == 413 {
            self.isScrollEnabled = false
        } else {
            self.isScrollEnabled = true
        }
        //self.isScrollEnabled = true
        self.next?.touchesBegan(touches, with: event)
        super.touchesBegan(touches, with: event)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        super.touchesEnded(touches, with: event)
        self.next?.touchesEnded(touches, with: event)
    }
}
