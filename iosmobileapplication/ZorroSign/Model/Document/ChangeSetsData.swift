//
//  ChangeSetsData.swift
//  ZorroSign
//
//  Created by Apple on 10/08/18.
//  Copyright © 2018 Apple. All rights reserved.
//

import UIKit

class ChangeSetsData: WSBaseData {

    /*
     "ChangeSets": [
     {
     "ExecutedBy": 205,
     "ExecutedTime": "2018-08-10T06:52:23",
     "TagType": 6,
     "ExecutedUserName": "",
     "CertificateNumber": null,
     "ExtendedMetaData": "",
     "DynamicTagtext": ""
     }
     ]
     */
    
    var ExecutedBy: Int?
    var ExecutedUserName: String?
    var ExecutedTime: String?
    var TagType: Int?
    var InstanceStepId: Int?
    
    override func populate(fromDictionary dict: NSDictionary) {
        super.populate(fromDictionary: dict)
    
        if let ExecutedBy = dict.object(forKey: "ExecutedBy") as? Int {
            self.ExecutedBy = ExecutedBy
        }
        if let ExecutedUserName = dict.object(forKey: "ExecutedUserName") as? String {
            self.ExecutedUserName = ExecutedUserName
        }
        if let ExecutedTime = dict.object(forKey: "ExecutedTime") as? String {
            self.ExecutedTime = ExecutedTime
        }
        if let TagType = dict.object(forKey: "TagType") as? Int {
            self.TagType = TagType
        }
    }
}
