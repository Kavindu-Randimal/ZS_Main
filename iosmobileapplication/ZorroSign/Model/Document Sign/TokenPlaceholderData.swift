//
//  TokenPlaceholderData.swift
//  ZorroSign
//
//  Created by Apple on 31/08/18.
//  Copyright © 2018 Apple. All rights reserved.
//

import UIKit

class TokenPlaceholderData: WSBaseData {

    var Height: CGFloat?
    var PageNumber: CGFloat?
    var Width: CGFloat?
    var XCoordinate: CGFloat?
    var YCoordinate: CGFloat?
    
    override func populate(fromDictionary dict: NSDictionary) {
        super.populate(fromDictionary: dict)
        
        if let Height = dict.object(forKey: "Height") as? CGFloat {
            self.Height = Height
        }
        if let PageNumber = dict.object(forKey: "PageNumber") as? CGFloat {
            self.PageNumber = PageNumber
        }
        if let Width = dict.object(forKey: "Width") as? CGFloat {
            self.Width = Width
        }
        if let XCoordinate = dict.object(forKey: "XCoordinate") as? CGFloat {
            self.XCoordinate = XCoordinate
        }
        if let YCoordinate = dict.object(forKey: "YCoordinate") as? CGFloat {
            self.YCoordinate = YCoordinate
        }
    }
    func toDictionary()-> [String: Any] {
        var dic: [String:Any] = [:]
        
        dic["Height"] = self.Height
        dic["Width"] = self.Width
        dic["PageNumber"] = self.PageNumber
        dic["XCoordinate"] = self.XCoordinate
        dic["YCoordinate"] = self.YCoordinate
        
        return dic
    }
}
