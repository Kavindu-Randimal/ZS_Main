//
//  PermissionData.swift
//  ZorroSign
//
//  Created by Apple on 10/10/18.
//  Copyright © 2018 Apple. All rights reserved.
//

import UIKit

class PermissionData: WSBaseData {

    /*
     ["ModifiedBy": 0, "PermissionGrantedProfileId": 2031, "ModifiedDate": 2018-10-01T18:43:39, "Identifier": 1fbdeb6bb46349a18bd1be3fab9365e3, "RequesterName": Ruwan SFone, "TokenId": 3644, "GzippedTokenId": H4sIAAAAAAAEAAsNsqjKDXF0SnQyK/VN9/FMjjS3zHdUNXYBIgA+clX0HAAAAA==, "Id": 716, "RequesterEmail": ruwan+sf1@entrusttitle.com, "Status": 2, "ThumbnailURL": xSz62q7nv0mQRNYC767Frg.png, "PermissionExpiryDate": 2018-10-15T18:43:39, "ObjectId": workspace://SpacesStore/888c1f96-6f97-4006-9a1c-1dd7a2361353;2.0, "DocumentName": Test Token, "PermissionReceivedProfileId": 2329, "PendingRequestCount": 3]
     */
    /*
     "Id": 919,
     "WorkflowId": 15843,
     "InstanceId": 11220,
     "PermissionGrantedProfileId": 11428,
     "PermissionReceivedProfileId": 11429,
     "ObjectId": "workspace://SpacesStore/d7c46bb5-095c-410f-bf4a-225d25a98663;1.0",
     "TokenId": 5925,
     "Status": 5,
     "DocumentShareType": 2,
     "ModifiedDate": "2018-12-27T13:08:15",
     "PermissionExpiryDate": "0001-01-01T00:00:00",
     "PendingRequestCount": 1,
     "Identifier": "18b7d1ac934147ad8a487ec8e9bfe341",
     "DocumentName": "Manage Permission Scanned Token",
     "RequesterName": "Anil Saindane",
     "RequesterEmail": "anil.hoh@gmail.com",
     "GzippedTokenId": "H4sIAAAAAAAEAKvINqosDa0Kdimv8jD286+IqEoycC9XNXYBIgAx7ubIHAAAAA==",
     "ThumbnailURL": "P7N4KZ1fvk6QyPPqjpi4xg.png"
     */
    var ModifiedBy: String?
    var PermissionGrantedProfileId: String?
    var ModifiedDate: String?
    var Identifier: String?
    var RequesterName: String?
    var TokenId: Int?
    var GzippedTokenId: String?
    var Id: Int?
    var RequesterEmail: String?
    var Status: Int?
    var ThumbnailURL: String?
    var PermissionExpiryDate: String?
    var ObjectId: String?
    var DocumentName: String?
    var PermissionReceivedProfileId: Int?
    var PendingRequestCount: Int?
    var WorkflowId: Int?
    var InstanceId: Int?
    var DocumentShareType: Int?
    var permDate: Date?
    
    override func populate(fromDictionary dict: NSDictionary) {
        super.populate(fromDictionary: dict)
        
        if let Identifier = dict.object(forKey: "Identifier") as? String {
            self.Identifier = Identifier
        }
        if let DocumentName = dict.object(forKey: "DocumentName") as? String {
            self.DocumentName = DocumentName
        }
        if let RequesterName = dict.object(forKey: "RequesterName") as? String {
            self.RequesterName = RequesterName
        }
        if let RequesterEmail = dict.object(forKey: "RequesterEmail") as? String {
            self.RequesterEmail = RequesterEmail
        }
        if let Status = dict.object(forKey: "Status") as? Int {
            self.Status = Status
        }
        
        if let tokenstr = dict.object(forKey: "GzippedTokenId") as? String {
            self.GzippedTokenId = tokenstr
        }
        if let WorkflowId = dict.object(forKey: "WorkflowId") as? Int {
            self.WorkflowId = WorkflowId
        }
        if let InstanceId = dict.object(forKey: "InstanceId") as? Int {
            self.InstanceId = InstanceId
        }
        if let DocumentShareType = dict.object(forKey: "DocumentShareType") as? Int {
            self.DocumentShareType = DocumentShareType
        }
        if let TokenId = dict.object(forKey: "TokenId") as? Int {
            self.TokenId = TokenId
        }
        if let ModifiedDate = dict.object(forKey: "ModifiedDate") as? String {
            self.ModifiedDate = ModifiedDate
            self.permDate = self.ModifiedDate?.stringToDate()
        }
    }
}
