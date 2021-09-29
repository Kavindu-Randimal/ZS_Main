//
//  ContactsData.swift
//  ZorroSign
//
//  Created by Apple on 13/09/18.
//  Copyright © 2018 Apple. All rights reserved.
//

import UIKit

class ContactsData: WSBaseData {

    var FullName: String?
    var Email: String?
    var IsZorroUser: Bool = false
    var ProfileId: String?
    var ContactProfileId: String?
    var FirstName: String?
    var MiddleName: String?
    var LastName: String?
    var Company: String?
    var JobTitle: String?
    var UserType: Int?
    var ContactId: Int?
    var DepartmentId: Int?
    var Thumbnail: String?
    var ThumbnailURL: String?
    var DefaultPhone: String?
    var HomePhone: String?
    var MobilePhone: String?
    var InternetEmail: String?
    var HomeEmail: String?
    var WorkEmail: String?
    var CellMsg: String?
    var HomeFax: String?
    var WorkPhone: String?
    var WorkFax: String?
    var Address: String?
    var AddressList: [[String:Any]]?
    var DobDate: String?
    var Other: String?
    var ZorroUserType: Int?
    var Website: String?
    var selected: Bool = false
    
    var IdNum: Int?
    var Id: String?
    var Name: String?
    var Description: String?
    var DepartmentName: String?
    var ContactType: Int?
    var UserCount: Int?
    var DisplayName: String?
    
    var linkedContacts: [ContactsData] = []
    
    /*
     {"ProfileId":"BOtwqPvVhvJ56JWW4SkcsA%3D%3D","ContactProfileId":"EMww7R7s82Nx2o379r18dA%3D%3D","FullName":"Prajakta Bhagwat Pawar","FirstName":"Prajakta","MiddleName":"Bhagwat","LastName":"Pawar","DisplayName":"Prajuu","Email":"prajakta.hoh@gmail.com","Company":"Test Legal Name","JobTitle":"tester","UserType":1,"ContactId":7123,"DepartmentId":278,"Thumbnail":"oxDjHZBBokSWFFRwyyDZuw.png","DefaultPhone":"123456789","HomePhone":"","MobilePhone":"","InternetEmail":"","HomeEmail":"","WorkEmail":"","CellMsg":"","HomeFax":"","WorkPhone":"","WorkFax":"","Address":null,"AddressList":null,"DobDate":"0001-01-01T00:00:00","IsZorroUser":true,"Other":"","ZorroUserType":null,"Website":""}
     */
    
    override func populate(fromDictionary dict: NSDictionary) {
        super.populate(fromDictionary: dict)
        
        if let ContactId = dict.object(forKey: "ContactId") as? Int {
            self.ContactId = ContactId
        }
        
        if let FullName = dict.object(forKey: "FullName") as? String {
            self.FullName = FullName
        }
        if let DisplayName = dict.object(forKey: "DisplayName") as? String {
            self.DisplayName = DisplayName
        }
        if let Email = dict.object(forKey: "Email") as? String {
            self.Email = Email
        }
        if let IsZorroUser = dict.object(forKey: "IsZorroUser") as? Bool {
            self.IsZorroUser = IsZorroUser
        }
        
        if let ContactProfileId = dict.object(forKey: "ContactProfileId") as? String {
            self.ContactProfileId = ContactProfileId
        }
        if let ProfileId = dict.object(forKey: "ProfileId") as? String {
            self.ProfileId = ProfileId
        }
        if let FirstName = dict.object(forKey: "FirstName") as? String {
            self.FirstName = FirstName
        }
        if let MiddleName = dict.object(forKey: "MiddleName") as? String {
            self.MiddleName = MiddleName
        }
        if let LastName = dict.object(forKey: "LastName") as? String {
            self.LastName = LastName
        }
        if let Company = dict.object(forKey: "Company") as? String {
            self.Company = Company
        }
        if let JobTitle = dict.object(forKey: "JobTitle") as? String {
            self.JobTitle = JobTitle
        }
        if let UserType = dict.object(forKey: "UserType") as? Int {
            self.UserType = UserType
        }
        if let DepartmentId = dict.object(forKey: "DepartmentId") as? Int {
            self.DepartmentId = DepartmentId
        }
        if let Thumbnail = dict.object(forKey: "Thumbnail") as? String, !Thumbnail.isEmpty {
            self.Thumbnail = Singletone.shareInstance.thumbBaseURL + Thumbnail
        }
        if let ThumbnailURL = dict.object(forKey: "ThumbnailURL") as? String {
            self.ThumbnailURL = Singletone.shareInstance.thumbBaseURL + ThumbnailURL
        }
        if let DefaultPhone = dict.object(forKey: "DefaultPhone") as? String {
            self.DefaultPhone = DefaultPhone
        }
        if let HomePhone = dict.object(forKey: "HomePhone") as? String {
            self.HomePhone = HomePhone
        }
        if let MobilePhone = dict.object(forKey: "MobilePhone") as? String {
            self.MobilePhone = MobilePhone
        }
        if let InternetEmail = dict.object(forKey: "InternetEmail") as? String {
            self.InternetEmail = InternetEmail
        }
        if let HomeEmail = dict.object(forKey: "HomeEmail") as? String {
            self.HomeEmail = HomeEmail
        }
        if let InternetEmail = dict.object(forKey: "InternetEmail") as? String {
            self.InternetEmail = InternetEmail
        }
        if let WorkEmail = dict.object(forKey: "WorkEmail") as? String {
            self.WorkEmail = WorkEmail
        }
        if let CellMsg = dict.object(forKey: "CellMsg") as? String {
            self.CellMsg = CellMsg
        }
        if let HomeFax = dict.object(forKey: "HomeFax") as? String {
            self.HomeFax = HomeFax
        }
        if let WorkPhone = dict.object(forKey: "WorkPhone") as? String {
            self.WorkPhone = WorkPhone
        }
        if let CellMsg = dict.object(forKey: "CellMsg") as? String {
            self.CellMsg = CellMsg
        }
        if let WorkFax = dict.object(forKey: "WorkFax") as? String {
            self.WorkFax = WorkFax
        }
        if let Address = dict.object(forKey: "Address") as? String {
            self.Address = Address
        }
        if let WorkFax = dict.object(forKey: "WorkFax") as? String {
            self.WorkFax = WorkFax
        }
        if let AddressList = dict.object(forKey: "AddressList") as? [[String:Any]] {
            self.AddressList = AddressList
        }
        if let DobDate = dict.object(forKey: "DobDate") as? String {
            self.DobDate = DobDate
        }
        if let Other = dict.object(forKey: "Other") as? String {
            self.Other = Other
        }
        if let ZorroUserType = dict.object(forKey: "ZorroUserType") as? Int {
            self.ZorroUserType = ZorroUserType
        }
        if let Website = dict.object(forKey: "Website") as? String {
            self.Website = Website
        }
        if let IdNum = dict.object(forKey: "IdNum") as? Int {
            self.IdNum = IdNum
        }
        if let ContactType = dict.object(forKey: "Type") as? Int {
            self.ContactType = ContactType
        }
        if let UserCount = dict.object(forKey: "UserCount") as? Int {
            self.UserCount = UserCount
        }
        if let Id = dict.object(forKey: "Id") as? String {
            self.Id = Id
        }
        if let Name = dict.object(forKey: "Name") as? String {
            self.Name = Name
        }
        if let Description = dict.object(forKey: "Description") as? String {
            self.Description = Description
        }
        if let DepartmentName = dict.object(forKey: "DepartmentName") as? String {
            self.DepartmentName = DepartmentName
        }
        
        if let SecContacts = dict.object(forKey: "SecondaryContact") as? [[String:Any]] {
            
            for dic in SecContacts {
                
                let contact = ContactsData(dictionary: dic)
                self.linkedContacts.append(contact)
            }
        }
    }
    
    func toDictionary() -> [String:Any]{
        
        var dic: [String:Any] = [:]
        
        dic["FullName"] = self.FullName ?? ""
        dic["Email"] = self.Email ?? ""
        dic["IsZorroUser"] = self.IsZorroUser
        dic["ProfileId"] = self.ProfileId ?? ""
        dic["ContactProfileId"] = self.ContactProfileId ?? ""
        dic["FirstName"] = self.FirstName ?? ""
        dic["MiddleName"] = self.MiddleName ?? ""
        dic["LastName"] = self.LastName ?? ""
        dic["Company"] = self.Company ?? ""
        dic["JobTitle"] = self.JobTitle ?? ""
        dic["UserType"] = self.UserType ?? 0
        dic["ContactId"] = self.ContactId ?? 0
        dic["DepartmentId"] = self.DepartmentId ?? 0
        dic["Thumbnail"] = self.Thumbnail ?? ""
        dic["ThumbnailURL"] = self.ThumbnailURL ?? ""
        dic["DefaultPhone"] = self.DefaultPhone ?? ""
        dic["HomePhone"] = self.HomePhone ?? ""
        dic["MobilePhone"] = self.MobilePhone ?? ""
        dic["InternetEmail"] = self.InternetEmail ?? ""
        dic["HomeEmail"] = self.HomeEmail ?? ""
        dic["WorkEmail"] = self.WorkEmail ?? ""
        dic["CellMsg"] = self.CellMsg ?? ""
        dic["HomeFax"] = self.HomeFax ?? ""
        dic["WorkPhone"] = self.WorkPhone ?? ""
        dic["WorkFax"] = self.WorkFax ?? ""
        dic["Address"] = self.Address ?? "<null>"
        dic["AddressList"] = []
        dic["DobDate"] = self.DobDate ?? ""
        dic["Other"] = self.Other ?? ""
        dic["ZorroUserType"] = self.ZorroUserType ?? "<null>"
        dic["Website"] = self.Website ?? ""
        dic["DisplayName"] = self.DisplayName ?? ""
        
        return dic
    }
}
/*
 "ProfileId": "PhGn%2BxqM3A9lcg56rD4kaw%3D%3D",
 "ContactProfileId": "FM7W8LlPpKtiV6J2vpmZKg%3D%3D",
 "FullName": "sample string 5",
 "FirstName": "sample string 6",
 "MiddleName": "sample string 7",
 "LastName": "sample string 8",
 "Email": "sample string 9",
 "Company": "sample string 10",
 "JobTitle": "sample string 11",
 "UserType": 1,
 "ContactId": 12,
 "DepartmentId": 13,
 "Thumbnail": "sample string 14",
 "ThumbnailURL": "sample string 15",
 "DefaultPhone": "sample string 16",
 "HomePhone": "sample string 17",
 "MobilePhone": "sample string 18",
 "InternetEmail": "sample string 19",
 "HomeEmail": "sample string 20",
 "WorkEmail": "sample string 21",
 "CellMsg": "sample string 22",
 "HomeFax": "sample string 23",
 "WorkPhone": "sample string 24",
 "WorkFax": "sample string 25",
 "Address": "sample string 26",
 "AddressList": [
 {
 "Line1": "sample string 1",
 "Line2": "sample string 2",
 "City": "sample string 3",
 "County": "sample string 4",
 "State": 0,
 "ZipCode": "sample string 5",
 "Country": "sample string 6",
 "Type": 1
 },
 {
 "Line1": "sample string 1",
 "Line2": "sample string 2",
 "City": "sample string 3",
 "County": "sample string 4",
 "State": 0,
 "ZipCode": "sample string 5",
 "Country": "sample string 6",
 "Type": 1
 }
 ],
 "DobDate": "2018-09-14T14:35:09.4663154+05:30",
 "IsZorroUser": true,
 "Other": "sample string 29",
 "ZorroUserType": 1,
 "Website": "sample string 30"
 */

/*
 {"IdNum":23529,"Id":"j8DLjmaI310DqFaH%2Bf228g%3D%3D","ContactProfileId":"rdU3LSrmE28zTnXBeWbL2A%3D%3D","Name":"ABC","Description":"","Email":"abc@abc.com","DepartmentName":null,"Type":1,"Thumbnail":"","UserCount":1,"IsZorroUser":false,"UserType":2,"Company":"HOH","JobTitle":"Tester"}
 */
