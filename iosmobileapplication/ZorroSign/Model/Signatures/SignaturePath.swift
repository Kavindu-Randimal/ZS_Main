//
//  SignaturePath.swift
//  ZorroSign
//
//  Created by Apple on 17/07/18.
//  Copyright © 2018 Apple. All rights reserved.
//

import Foundation

@objc class SignaturePath: WSBaseData {
    
    var startPoint: CGPoint?
    var endPoint: CGPoint?
    var control1: CGPoint?
    var control2: CGPoint?
    
    
    override func populate(fromDictionary dict: NSDictionary) {
        super.populate(fromDictionary: dict)
    
        if let startPoint = dict.object(forKey: "startPoint") as? [String:Double] {
            self.startPoint = CGPoint(x: startPoint["x"]!, y: startPoint["y"]!)
        }
        if let endPoint = dict.object(forKey: "endPoint") as? [String:Double] {
            self.endPoint = CGPoint(x: endPoint["x"]!, y: endPoint["y"]!)
        }
        if let control1 = dict.object(forKey: "control1") as? [String:Double] {
            self.control1 = CGPoint(x: control1["x"]!, y: control1["y"]!)
        }
        if let control2 = dict.object(forKey: "control2") as? [String:Double] {
            self.control2 = CGPoint(x: control2["x"]!, y: control2["y"]!)
        }
    }
}
