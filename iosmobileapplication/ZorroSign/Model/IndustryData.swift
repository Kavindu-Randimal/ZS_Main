//
//  IndustryData.swift
//  ZorroSign
//
//  Created by Apple on 04/08/18.
//  Copyright © 2018 Apple. All rights reserved.
//

import UIKit

class IndustryData: WSBaseData {

    var Key: Int?
    var Value: String?
    
    override func populate(fromDictionary dict: NSDictionary) {
        super.populate(fromDictionary: dict)
        
        if let key = dict.object(forKey: "Key") as? Int {
            self.Key = key
        }
        if let value = dict.object(forKey: "Value") as? String {
            self.Value = value
        }
    }
}
