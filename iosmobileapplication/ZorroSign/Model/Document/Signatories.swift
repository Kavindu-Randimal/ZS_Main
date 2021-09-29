//
//  Signatories.swift
//  ZorroSign
//
//  Created by Apple on 08/09/18.
//  Copyright © 2018 Apple. All rights reserved.
//

import UIKit

class Signatories: WSBaseData {

    /*
     Signatories =                     (
     {
     FriendlyName = "<null>";
     Id = "F%2BnxcRjh5o8J1DmN%2Bn8Qtg%3D%3D";
     ProfileImage = "<null>";
     Type = 1;
     UserName = "<null>";
     }
     );
     */
    var FriendlyName: String?
    var Id: String?
    var ProfileImage: String?
    var type: Int?
    var UserName: String?
    var TagNo: Int = 0
    var isCC: Bool = false
    var state: Int = 0
    
    override func populate(fromDictionary dict: NSDictionary) {
        super.populate(fromDictionary: dict)
        
        if let FriendlyName = dict.object(forKey: "FriendlyName") as? String {
            self.FriendlyName = FriendlyName
        }
        if let Id = dict.object(forKey: "Id") as? String {
            self.Id = Id
        }
        if let ProfileImage = dict.object(forKey: "ProfileImage") as? String {
            self.ProfileImage = ProfileImage
        }
        if let type = dict.object(forKey: "Type") as? Int {
            self.type = type
        }
        if let UserName = dict.object(forKey: "UserName") as? String {
            self.UserName = UserName
        }
    }
    func toDictionary()-> [String: Any] {
        var dic: [String:Any] = [:]
        
        dic["Id"] = self.Id
        dic["Type"] = self.type
        dic["UserName"] = self.UserName ?? ""
        dic["FriendlyName"] = self.FriendlyName ?? ""
        dic["ProfileImage"] = self.ProfileImage ?? ""
        
        return dic
    }
}
