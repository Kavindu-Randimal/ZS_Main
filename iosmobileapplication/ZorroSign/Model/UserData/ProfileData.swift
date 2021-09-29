//
//  ProfileData.swift
//  ZorroSign
//
//  Created by Apple on 04/10/18.
//  Copyright © 2018 Apple. All rights reserved.
//

import UIKit

class ProfileData: WSBaseData {

    var ProfileId: String = ""
    var UserId: String = ""
    var OrganizationId: String = ""
    var DepartmentId: Int = 0
    var Email: String = ""
    var FirstName: String = ""
    var MiddleName: String = ""
    var MiddleInitials: String = ""
    var LastName: String = ""
    var Rating: Float = 0.0
    var Link: String = ""
    var Locale: String = ""
    var Picture: String = ""
    var Thumbnail: String = ""
    var ThumbnailURL: String?
    var IsActive: Bool = false
    var IsDeleted: Bool = false
    var IsWelcomeVisible: Bool = false
    var IsDefault: Bool = false
    var AddressLine1: String = ""
    var AddressLine2: String = ""
    var ZipCode: String = ""
    var StateCode: String = ""
    var City: String = ""
    var County: String = ""
    var Country: String = ""
    var CountryCode: String = ""
    var Address: String = ""
    var OfficialName: String = ""
    var Suffix: String = ""
    var Title: String = ""
    var JobTitle: String = ""
    var PhoneNumber: String = ""
    var UserSignatureId: Int = 0
    var Signature: String = ""
    var Initials: String = ""
    var SignatureDescriptionData: SignatureDescription?
    var UserSignaturesData: [UserSignatures] = []
    var ProfileStatus: Int = 0
    var SettingsData: Settings?
    var CreatedBy: String = ""
    var ModifiedBy: String = ""
    var UserType: Int = 0
    var Roles: [RoleData] = []
    
    
    override func populate(fromDictionary dict: NSDictionary) {
        super.populate(fromDictionary: dict)
        
        if let ProfileId = dict.object(forKey: "ProfileId") as? String {
            self.ProfileId = ProfileId
        }
        if let UserId = dict.object(forKey: "UserId") as? String {
            self.UserId = UserId
        }
        if let OrganizationId = dict.object(forKey: "OrganizationId") as? String {
            self.OrganizationId = OrganizationId
        }
        if let Email = dict.object(forKey: "Email") as? String {
            self.Email = Email
        }
        if let FirstName = dict.object(forKey: "FirstName") as? String {
            self.FirstName = FirstName
        }
        if let MiddleName = dict.object(forKey: "MiddleName") as? String {
            self.MiddleName = MiddleName
        }
        if let MiddleInitials = dict.object(forKey: "MiddleInitials") as? String {
            self.MiddleInitials = MiddleInitials
        }
        if let LastName = dict.object(forKey: "LastName") as? String {
            self.LastName = LastName
        }
        if let Rating = dict.object(forKey: "Rating") as? Float {
            self.Rating = Rating
        }
        if let Link = dict.object(forKey: "Link") as? String {
            self.Link = Link
        }
        if let Locale = dict.object(forKey: "Locale") as? String {
            self.Locale = Locale
        }
        if let Picture = dict.object(forKey: "Picture") as? String {
            self.Picture = Picture
        }
        if let Thumbnail = dict.object(forKey: "Thumbnail") as? String {
            self.Thumbnail = Thumbnail
        }
        if let ThumbnailURL = dict.object(forKey: "ThumbnailURL") as? String {
            self.ThumbnailURL = ThumbnailURL
        }
        if let IsActive = dict.object(forKey: "IsActive") as? Bool {
            self.IsActive = IsActive
        }
        if let IsDeleted = dict.object(forKey: "IsDeleted") as? Bool {
            self.IsDeleted = IsDeleted
        }
        if let IsWelcomeVisible = dict.object(forKey: "IsWelcomeVisible") as? Bool {
            self.IsWelcomeVisible = IsWelcomeVisible
        }
        if let IsDefault = dict.object(forKey: "IsDefault") as? Bool {
            self.IsDefault = IsDefault
        }
        if let AddressLine1 = dict.object(forKey: "AddressLine1") as? String {
            self.AddressLine1 = AddressLine1
        }
        if let AddressLine2 = dict.object(forKey: "AddressLine2") as? String {
            self.AddressLine2 = AddressLine2
        }
        if let ZipCode = dict.object(forKey: "ZipCode") as? String {
            self.ZipCode = ZipCode
        }
        if let StateCode = dict.object(forKey: "StateCode") as? String {
            self.StateCode = StateCode
        }
        if let City = dict.object(forKey: "City") as? String {
            self.City = City
        }
        if let County = dict.object(forKey: "County") as? String {
            self.County = County
        }
        if let Country = dict.object(forKey: "Country") as? String {
            self.Country = Country
        }
        if let CountryCode = dict.object(forKey: "CountryCode") as? String {
            self.CountryCode = CountryCode
        }
        if let Address = dict.object(forKey: "Address") as? String {
            self.Address = Address
        }
        if let OfficialName = dict.object(forKey: "OfficialName") as? String {
            self.OfficialName = OfficialName
        }
        if let Suffix = dict.object(forKey: "Suffix") as? String {
            self.Suffix = Suffix
        }
        if let Title = dict.object(forKey: "Title") as? String {
            self.Title = Title
        }
        if let JobTitle = dict.object(forKey: "JobTitle") as? String {
            self.JobTitle = JobTitle
        }
        if let PhoneNumber = dict.object(forKey: "PhoneNumber") as? String {
            self.PhoneNumber = PhoneNumber
        }
        if let UserSignatureId = dict.object(forKey: "UserSignatureId") as? Int {
            self.UserSignatureId = UserSignatureId
        }
        if let Signature = dict.object(forKey: "Signature") as? String {
            self.Signature = Signature
        }
        if let Initials = dict.object(forKey: "Initials") as? String {
            self.Initials = Initials
        }
        if let SignatureDescriptionData = dict.object(forKey: "SignatureDescription") as? [String:Any] {
            self.SignatureDescriptionData = SignatureDescription(dictionary: SignatureDescriptionData)
        }
        if let UserSignaturesData = dict.object(forKey: "UserSignatures") as? [[String:Any]] {
            self.UserSignaturesData = []
            
            for dic in UserSignaturesData {
                self.UserSignaturesData.append(UserSignatures(dictionary: dic))
            }
        }
        if let ProfileStatus = dict.object(forKey: "ProfileStatus") as? Int {
            self.ProfileStatus = ProfileStatus
        }
        if let SettingsData = dict.object(forKey: "Settings") as? [String:Any] {
            self.SettingsData = Settings(dictionary: SettingsData)
        }
        if let CreatedBy = dict.object(forKey: "CreatedBy") as? String {
            self.CreatedBy = CreatedBy
        }
        if let ModifiedBy = dict.object(forKey: "ModifiedBy") as? String {
            self.ModifiedBy = ModifiedBy
        }
        if let UserType = dict.object(forKey: "UserType") as? Int {
            self.UserType = UserType
        }
        if let JobTitle = dict.object(forKey: "JobTitle") as? String {
            self.JobTitle = JobTitle
        }
    }
    
    /*
     [{"ProfileId":"9qrdcUikcMEqns391XocSw%3D%3D","UserId":"H62mAmIk4Ty9tsb2HGQJ%2Fw%3D%3D","OrganizationId":"37VBXu3HN1QTfr7SANccTg%3D%3D","Email":"a@bc.com","FirstName":"abc","MiddleName":"abc","MiddleInitials":"","LastName":"abc","Rating":0,"Link":"","Locale":"","Picture":"","Thumbnail":"","ThumbnailURL":"","IsActive":true,"IsDeleted":false,"IsWelcomeVisible":false,"IsVideoHelpVisible":false,"IsDefault":false,"AddressLine1":"","AddressLine2":"","ZipCode":"","StateCode":"","City":"","County":"","Country":"","CountryCode":"","Address":"","OfficialName":"","Suffix":"","Title":"Ms","JobTitle":"tester","PhoneNumber":"123456788","UserSignatureId":0,"Signature":"","Initials":"","SignatureDescription":null,"UserSignatures":null,"ProfileStatus":2,"Settings":null,"CreatedBy":null,"ModifiedBy":null,"UserType":1,"IsMerged":false,"BusinessName":"","DepartmentId":"0"}]
     */
    
    func toDictionary()-> NSMutableDictionary {
        let dic: NSMutableDictionary = NSMutableDictionary.init()
        
        dic["ProfileId"] = self.ProfileId
        dic["UserId"] = self.UserId
        dic["OrganizationId"] = self.OrganizationId
        dic["Email"] = self.Email
        dic["FirstName"] = self.FirstName
        dic["MiddleName"] = self.MiddleName
        dic["LastName"] = self.LastName
        //dic["MiddleInitials"] = self.MiddleInitials
        //dic["Rating"] = self.Rating
        //dic["Link"] = self.Link
        //dic["Locale"] = self.Locale
        //dic["Picture"] = self.Picture
        //dic["Thumbnail"] = self.Thumbnail
        //dic["ThumbnailURL"] = self.ThumbnailURL
        dic["IsActive"] = self.IsActive
        dic["IsDeleted"] = self.IsDeleted
        //dic["IsWelcomeVisible"] = self.IsWelcomeVisible
        //dic["IsDefault"] = self.IsDefault
        //dic["AddressLine1"] = self.AddressLine1
        //dic["AddressLine2"] = self.AddressLine2
        //dic["ZipCode"] = self.ZipCode
        //dic["StateCode"] = self.StateCode
        //dic["City"] = self.City
        //dic["County"] = self.County
        //dic["Country"] = self.Country
        //dic["CountryCode"] = self.CountryCode
        //dic["Address"] = self.Address
        //dic["OfficialName"] = self.OfficialName
        //dic["Suffix"] = self.Suffix
        dic["Title"] = self.Title
        dic["JobTitle"] = self.JobTitle
        //dic["Suffix"] = self.Suffix
        dic["JobTitle"] = self.JobTitle
        dic["PhoneNumber"] = self.PhoneNumber
        //dic["UserSignatureId"] = self.UserSignatureId
        dic["Signature"] = self.Signature
        dic["Initials"] = self.Initials
        //dic["Roles"] = self.Roles
        /*
        dic["SignatureDescription"] = self.SignatureDescriptionData
        dic["UserSignatures"] = self.UserSignaturesData
        dic["ProfileStatus"] = self.ProfileStatus
        dic["Settings"] = self.SettingsData
        dic["CreatedBy"] = self.CreatedBy
        dic["ModifiedBy"] = self.ModifiedBy
        dic["UserType"] = self.UserType
        */
        return dic
    }
}
