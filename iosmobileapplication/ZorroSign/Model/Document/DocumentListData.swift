//
//  DocumentListData.swift
//  ZorroSign
//
//  Created by Apple on 10/08/18.
//  Copyright © 2018 Apple. All rights reserved.
//

import UIKit

class DocumentListData: WSBaseData {

    /*
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
     )
     */
    /* DocType = 0- Main document, 1- Attachment */
    /* Attached user  = Attachment added user, */
    
    /*
     1000 : user has access to document and can view audit trail
     1500 : user requested the permission to access the document
     3904 : permission requested and it is in pending status
     3908: Permissions cannot be granted for this Token version.
     
     if user has access (i.e status code = 1000), you need to call GetDocumentTrail method to get audit trail
     */
    
    /*
     DocType = 0 => Main document, DocType=1 => attachements, DocType = 2 => standard document (template document) 
     */
    
    var AttachedUser: String?
    var AttachedUserProfileId: Int?
    var DocType: Int? //main document always pdf
    var IsDeletable: Int?
    var Name: String?
    var ObjectId: String?
    var OriginalName: String?
    
    override func populate(fromDictionary dict: NSDictionary) {
        super.populate(fromDictionary: dict)
        
        if let AttachedUser = dict.object(forKey: "AttachedUser") as? String {
            self.AttachedUser = AttachedUser
        }
        if let AttachedUserProfileId = dict.object(forKey: "AttachedUserProfileId") as? Int {
            self.AttachedUserProfileId = AttachedUserProfileId
        }
        if let DocType = dict.object(forKey: "DocType") as? Int {
            self.DocType = DocType
        }
        if let IsDeletable = dict.object(forKey: "IsDeletable") as? Int {
            self.IsDeletable = IsDeletable
        }
        if let Name = dict.object(forKey: "Name") as? String {
            self.Name = Name
        }
        if let ObjectId = dict.object(forKey: "ObjectId") as? String {
            self.ObjectId = ObjectId
        }
        if let OriginalName = dict.object(forKey: "OriginalName") as? String {
            self.OriginalName = OriginalName
        }
    }
}
