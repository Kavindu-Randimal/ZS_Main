//
//  AccountData.swift
//  ZorroSign
//
//  Created by Apple on 04/10/18.
//  Copyright © 2018 Apple. All rights reserved.
//

import UIKit

class AccountData: WSBaseData {

    var UserID: String?
    var SPassId: String?
    var Email: String?
    var OrganizationId: String?
    var DepartmentId: Int = 0
    var IsActive: Bool = false
    var IsDeleted: Bool = false
    var IsLocked: Bool = false
    var Status: Int?
    var UserType: Int?
    var Roles: [RoleData] = []
    var Permissions: [String] = []
    var ProfileCompletionStatus: Int?
    var IsSubscribed: Bool = false
    var CreatedBy: String?
    var ModifiedBy: String?
    var SubscriptionExpiryDate: String?
    var Thumbnail: String = ""
    
    override func populate(fromDictionary dict: NSDictionary) {
        super.populate(fromDictionary: dict)
        
        if let UserID = dict.object(forKey: "UserID") as? String {
            self.UserID = UserID
        }
        if let SPassId = dict.object(forKey: "SPassId") as? String {
            self.SPassId = SPassId
        }
        if let Email = dict.object(forKey: "Email") as? String {
            self.Email = Email
        }
        if let OrganizationId = dict.object(forKey: "OrganizationId") as? String {
            self.OrganizationId = OrganizationId
        }
        if let DepartmentId = dict.object(forKey: "DepartmentId") as? Int {
            self.DepartmentId = DepartmentId
        }
        if let IsActive = dict.object(forKey: "IsActive") as? Bool {
            self.IsActive = IsActive
        }
        if let IsDeleted = dict.object(forKey: "IsDeleted") as? Bool {
            self.IsDeleted = IsDeleted
        }
        if let IsLocked = dict.object(forKey: "IsLocked") as? Bool {
            self.IsLocked = IsLocked
        }
        if let Status = dict.object(forKey: "Status") as? Int {
            self.Status = Status
        }
        if let UserType = dict.object(forKey: "UserType") as? Int {
            self.UserType = UserType
        }
        if let roleDic = dict.object(forKey: "Roles") as? [[String:Any]] {
            self.Roles = []
            
            for dic in roleDic {
                self.Roles.append(RoleData(dictionary: dic))
            }
        }
        if let permissions = dict.object(forKey: "Permissions") as? [String] {
            self.Permissions = []
            
            for str in permissions {
                self.Permissions.append(str)
            }
        }
        if let ProfileCompletionStatus = dict.object(forKey: "ProfileCompletionStatus") as? Int {
            self.ProfileCompletionStatus = ProfileCompletionStatus
        }
        if let IsSubscribed = dict.object(forKey: "IsSubscribed") as? Bool {
            self.IsSubscribed = IsSubscribed
        }
        if let CreatedBy = dict.object(forKey: "CreatedBy") as? String {
            self.CreatedBy = CreatedBy
        }
        if let ModifiedBy = dict.object(forKey: "ModifiedBy") as? String {
            self.ModifiedBy = ModifiedBy
        }
        if let SubscriptionExpiryDate = dict.object(forKey: "SubscriptionExpiryDate") as? String {
            self.SubscriptionExpiryDate = SubscriptionExpiryDate
        }
    }
    
    func toDictionary()-> NSMutableDictionary {
        let dic: NSMutableDictionary = NSMutableDictionary.init()
        
        dic["UserID"] = self.UserID
        dic["SPassId"] = self.SPassId
        dic["Email"] = self.Email
        dic["OrganizationId"] = self.OrganizationId
        dic["DepartmentId"] = self.DepartmentId
        dic["IsActive"] = self.IsActive
        dic["IsDeleted"] = self.IsDeleted
        dic["IsLocked"] = self.IsLocked
        dic["Status"] = self.Status
        dic["UserType"] = self.UserType
        dic["Roles"] = self.Roles
        dic["Permissions"] = self.Permissions
        dic["ProfileCompletionStatus"] = self.ProfileCompletionStatus
        dic["IsSubscribed"] = self.IsSubscribed
        dic["CreatedBy"] = self.CreatedBy
        dic["ModifiedBy"] = self.ModifiedBy
        dic["SubscriptionExpiryDate"] = self.SubscriptionExpiryDate
        
        return dic
    }
    
}
