//
//  DocumentData.swift
//  ZorroSign
//
//  Created by Apple on 10/08/18.
//  Copyright © 2018 Apple. All rights reserved.
//

import UIKit

class DocumentData: WSBaseData {

    /*
     {
     DocumentList =     (
     {
     AttachedUser = "<null>";
     AttachedUserProfileId = 0;
     DocType = 0;
     IsDeletable = 0;
     Name = "wallpaper2you_338909";
     ObjectId = "workspace://SpacesStore/5f676e28-c43a-4e3f-9249-74bf10e39ca7;1.0";
     OriginalName = "<null>";
     }
     );
     DocumentSetName = Test123;
     FileName = "wallpaper2you_338909";
     ObjectId = "workspace://SpacesStore/5f676e28-c43a-4e3f-9249-74bf10e39ca7;1.0";
     ProcessId = 0;
     }
     */
    
    var DocumentList: [DocumentListData]?
    var DocumentSetName: String?
    var FileName: String?
    var ObjectId: String?
    var ProcessId: Int?
    
    override func populate(fromDictionary dict: NSDictionary) {
        super.populate(fromDictionary: dict)
        
        if let DocumentSetName = dict.object(forKey: "DocumentSetName") as? String {
            self.DocumentSetName = DocumentSetName
        }
        if let FileName = dict.object(forKey: "FileName") as? String {
            self.FileName = FileName
        }
        if let ObjectId = dict.object(forKey: "ObjectId") as? String {
            self.ObjectId = ObjectId
        }
        if let ProcessId = dict.object(forKey: "ProcessId") as? Int {
            self.ProcessId = ProcessId
        }
        
        if let doclist = dict.object(forKey: "DocumentList") as? [[String:Any]] {
            
            for dic in doclist {
                let list = DocumentListData(dictionary: dic)
                self.DocumentList = []
                self.DocumentList?.append(list)
            }
        }
    
    }
}
