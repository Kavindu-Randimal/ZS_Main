//
//  DocumentTrailData.swift
//  ZorroSign
//
//  Created by Apple on 10/08/18.
//  Copyright © 2018 Apple. All rights reserved.
//

import UIKit

class DocumentTrailData: WSBaseData {

    /*
     {
     "History": {
     "History": {
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
     ],
     "Attachments": []
     },
     "Downloads": []
     },
     "TokenId": 0,
     "WorkflowId": 0,
     "InstanceId": 0,
     "InstanceStepId": 3,
     "FileName": "wallpaper2you_338909"
     }
     */
    
    var HistoryData: History?
    var InstanceStepId: Int?
    var InstanceId: Int?
    var stepDic: [Int:[Int:[Int]]] = [:]
    var tagPerson: [Int: String] = [:]
    
    override func populate(fromDictionary dict: NSDictionary) {
        super.populate(fromDictionary: dict)
    
        if let history = dict.object(forKey: "History") as? [String:Any] {
           self.HistoryData = History(dictionary: history["History"] as! [AnyHashable : Any])
            
        }
        if let stepId = dict.object(forKey: "InstanceStepId") as? Int {
            
            self.InstanceStepId = stepId
        }
        if let InstanceId = dict.object(forKey: "InstanceId") as? Int {
            self.InstanceId = InstanceId
        }
        
        if let changesets = self.HistoryData?.ChangeSets as? [ChangeSetsData]{
            
            var typeArr: [Int:[Int]] = [:]
            
            for data in changesets {
                
                let chagesetdata = data as! ChangeSetsData
                
                if chagesetdata.TagType! != 8 && chagesetdata.TagType! != 14 {
                    
                    if stepDic[chagesetdata.ExecutedBy!] == nil {
                        typeArr.removeAll()
                    }
                    if let arr = typeArr[chagesetdata.TagType!] {
                        typeArr[chagesetdata.TagType!]?.append(chagesetdata.TagType!)
                    } else {
                        var arr:[Int] = []
                        arr.append(chagesetdata.TagType!)
                        typeArr[chagesetdata.TagType!] = arr
                    }
                    //typeArr[tagdata.type!]?.append(tagdata.type!)
                    stepDic[chagesetdata.ExecutedBy!] = typeArr
                    tagPerson[chagesetdata.ExecutedBy!] = chagesetdata.ExecutedUserName
                }
            }
            
        }
        
    }
}
