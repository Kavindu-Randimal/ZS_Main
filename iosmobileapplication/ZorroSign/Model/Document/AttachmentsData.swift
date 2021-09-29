//
//  AttachmentsData.swift
//  ZorroSign
//
//  Created by Apple on 16/08/18.
//  Copyright © 2018 Apple. All rights reserved.
//

import UIKit

class AttachmentsData: WSBaseData {

    /*
     {
     AttachedFileName = "if_kworldclock_7250.png";
     AttachedObjectId = "workspace://SpacesStore/fd44e32b-c8b7-4154-b394-9392def33e55;1.0";
     AttachedProfileId = 205;
     AttachedUserName = "Ruwan lastname";
     }
     */
    var AttachedFileName: String?
    var AttachedObjectId: String?
    var AttachedProfileId: Int?
    var AttachedUserName: String?
    
    override func populate(fromDictionary dict: NSDictionary) {
        super.populate(fromDictionary: dict)
        
        if let AttachedFileName = dict.object(forKey: "AttachedFileName") as? String {
            self.AttachedFileName = AttachedFileName
        }
        if let AttachedObjectId = dict.object(forKey: "AttachedObjectId") as? String {
            self.AttachedObjectId = AttachedObjectId
        }
        if let AttachedProfileId = dict.object(forKey: "AttachedProfileId") as? Int {
            self.AttachedProfileId = AttachedProfileId
        }
        if let AttachedUserName = dict.object(forKey: "AttachedUserName") as? String {
            self.AttachedUserName = AttachedUserName
        }
    }
}
