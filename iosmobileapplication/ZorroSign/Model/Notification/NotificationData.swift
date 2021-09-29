//
//  NotificationData.swift
//  ZorroSign
//
//  Created by Apple on 09/01/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit

class NotificationData: WSBaseData {

    /*
     "Id": 1,
     "Email": "sample string 2",
     "ProfileId": "",
     "DeviceId": null,
     "ProcessId": 0,
     "WorkflowId": 0,
     "MessageBody": null,
     "MessageTitle": null,
     "MessageLabel": null,
     "SentDate": "0001-01-01T00:00:00",
     "IsDeleted": false,
     "IsRead": false
     */
    
    var Id: Int?
    var Email: String?
    var ProfileId: String?
    var DeviceId: String?
    var ProcessId: Int?
    var WorkflowId: Int?
    var MessageBody: String?
    var MessageTitle: String?
    var MessageLabel: String?
    var SentDate: String?
    var IsDeleted: Bool = false
    var IsRead: Bool = false
    var NotificationType: Int?
    var notifDate: Date?
    var metaData: String?
    
    override func populate(fromDictionary dict: NSDictionary) {
        super.populate(fromDictionary: dict)
        
        if let Id = dict.object(forKey: "Id") as? Int {
            self.Id = Id
        } else if let Id = dict.object(forKey: "Id") as? String {
            self.Id = Int(Id)
        }
        if let ProcessId = dict.object(forKey: "ProcessId") as? String {
            self.ProcessId = Int(ProcessId)
        } else if let ProcessId = dict.object(forKey: "ProcessId") as? Int {
            self.ProcessId = ProcessId
        }
        if let ProcessId = dict.object(forKey: "processId") as? String {
            self.ProcessId = Int(ProcessId)
        }
        if let WorkflowId = dict.object(forKey: "WorkflowId") as? Int {
            self.WorkflowId = WorkflowId
        }
        if let Email = dict.object(forKey: "Email") as? String {
            self.Email = Email
        }
        if let ProfileId = dict.object(forKey: "ProfileId") as? String {
            self.ProfileId = ProfileId
        }
        if let DeviceId = dict.object(forKey: "DeviceId") as? String {
            self.DeviceId = DeviceId
        }
        if let MessageBody = dict.object(forKey: "MessageBody") as? String {
            self.MessageBody = MessageBody
        }
        if let MessageTitle = dict.object(forKey: "MessageTitle") as? String {
            self.MessageTitle = MessageTitle
        }
        if let MessageLabel = dict.object(forKey: "MessageLabel") as? String {
            self.MessageLabel = MessageLabel
        }
        if let SentDate = dict.object(forKey: "SentDate") as? String {
            self.SentDate = SentDate
            self.notifDate = self.SentDate?.stringToDate()
        }
        if let IsDeleted = dict.object(forKey: "IsDeleted") as? Bool {
            self.IsDeleted = IsDeleted
        }
        if let IsRead = dict.object(forKey: "IsRead") as? Bool {
            self.IsRead = IsRead
        }
        if let NotificationType = dict.object(forKey: "NotificationType") as? Int {
            self.NotificationType = NotificationType
        }
        if let type = dict.object(forKey: "type") as? String {
            self.NotificationType = Int(type)
        }
        if let title = dict.object(forKey: "title") as? String {
            self.MessageTitle = title
        }
        if let body = dict.object(forKey: "body") as? String {
            self.MessageBody = body
        }
        if let metadata = dict.object(forKey: "metaData") as? String {
            self.metaData = metadata
        }
    }
}
