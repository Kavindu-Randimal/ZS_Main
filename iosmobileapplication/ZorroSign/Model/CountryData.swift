//
//  CountryData.swift
//  ZorroSign
//
//  Created by Apple on 04/08/18.
//  Copyright © 2018 Apple. All rights reserved.
//

import UIKit

class CountryData: WSBaseData {

    var Code: String?
    var Name: String?
    
    override func populate(fromDictionary dict: NSDictionary) {
        super.populate(fromDictionary: dict)
        
        if let code = dict.object(forKey: "Code") as? String {
            self.Code = code
        }
        if let name = dict.object(forKey: "Name") as? String {
            self.Name = name
        }
    }
}
