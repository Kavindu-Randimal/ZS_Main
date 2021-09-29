//
//  SignatureDescription.swift
//  ZorroSign
//
//  Created by Apple on 18/07/18.
//  Copyright © 2018 Apple. All rights reserved.
//

import Foundation

@objc class SignatureDescription: WSBaseData {
    
    var DescriptionKey:String?
    var DescriptionText:String?
    var DescriptionValue:String?
    var Reason:String?
    
    override func populate(fromDictionary dict: NSDictionary) {
        super.populate(fromDictionary: dict)
        
        if dict.object(forKey: "DescriptionKey") != nil {
            self.DescriptionKey = dict.object(forKey: "DescriptionKey") as? String
        }
        if dict.object(forKey: "DescriptionText") != nil {
            self.DescriptionText = dict.object(forKey: "DescriptionText") as? String
        }
        if dict.object(forKey: "DescriptionValue") != nil {
            self.DescriptionValue = dict.object(forKey: "DescriptionValue") as? String
        }
        if dict.object(forKey: "Reason") != nil {
            self.Reason = dict.object(forKey: "Reason") as? String
        }
    }
    
    func  toDictionary()-> NSMutableDictionary {
        let dic: NSMutableDictionary = NSMutableDictionary.init()
        
        dic["DescriptionKey"] = self.DescriptionKey
        dic["DescriptionText"] = self.DescriptionText
        dic["DescriptionValue"] = self.DescriptionValue
        dic["Reason"] = self.Reason
        
        return dic
    }
}
