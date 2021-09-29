//
//  RoleData.swift
//  ZorroSign
//
//  Created by Apple on 01/10/18.
//  Copyright © 2018 Apple. All rights reserved.
//

import UIKit

class RoleData: WSBaseData {

    var RoleId: Int?
    var Name: String?
    var IsDefault: Bool = false
    var Permissions: [Int] = []
    var selected: Bool = false
    
    override func populate(fromDictionary dict: NSDictionary) {
        super.populate(fromDictionary: dict)
        
        if let RoleId = dict.object(forKey: "RoleId") as? Int {
            self.RoleId = RoleId
        }
        if let Name = dict.object(forKey: "Name") as? String {
            self.Name = Name
        }
        if let IsDefault = dict.object(forKey: "IsDefault") as? Bool {
            self.IsDefault = IsDefault
        }
        if let arrPermi = dict.object(forKey: "Permissions") as? [Int] {
            self.Permissions = []
            
            for data in arrPermi {
                self.Permissions.append(data)
            }
        }
        
    }
    func toDictionary()-> NSMutableDictionary {
        let dic: NSMutableDictionary = NSMutableDictionary.init()
        
        dic["RoleId"] = self.RoleId
        dic["Name"] = self.Name
        dic["IsDefault"] = self.IsDefault
        dic["Permissions"] = self.Permissions
        
        return dic
    }
}
