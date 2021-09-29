//
//  File.swift
//  ZorroSign
//
//  Created by Anuradh Caldera on 5/22/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import Foundation

struct UserProfileUpdate: Codable {
    
    var ProfileId, UserId, OrganizationId, Email: String?
    var FirstName, MiddleName, MiddleInitials, LastName: String?
    var Rating: Int?
    var Link, WebSite, Locale, Picture, Thumbnail: String?
    var ThumbnailURL: String?
    var IsActive, IsDeleted, IsWelcomeVisible, IsVideoHelpVisible: Bool?
    var IsDefault: Bool?
    var AddressLine1, AddressLine2, ZipCode, StateCode: String?
    var City, County, Country, CountryCode: String?
    var Address, OfficialName, Suffix, Title: String?
    var JobTitle, OfficePhoneNumber, OfficePhoneContryCode, PhoneContryCode, PhoneNumber: String?
    var UserSignatureID: Int?
    var Signature, Initials: String?
    var SignatureDescription: SignatDescription?
    var UserSignatures: [UserSignature]?
    var ProfileStatus: Int?
    var Settings: UserSettings?
    var CreatedBy, ModifiedBy: String?
    var UserType: Int?
    var BusinessName: String?
    
    init(userprofile: UserProfile) {
        self.ProfileId = userprofile.Data?.ProfileId
        self.UserId = userprofile.Data?.UserId
        self.OrganizationId = userprofile.Data?.OrganizationId
        self.Email = userprofile.Data?.Email
        self.FirstName = userprofile.Data?.FirstName
        self.MiddleName = userprofile.Data?.MiddleName
        self.AddressLine1 = userprofile.Data?.AddressLine1
        self.AddressLine2 = userprofile.Data?.AddressLine2
        self.City = userprofile.Data?.City
        self.StateCode = userprofile.Data?.StateCode
        self.ZipCode = userprofile.Data?.ZipCode
        self.Country = userprofile.Data?.Country
        self.MiddleInitials = userprofile.Data?.MiddleInitials
        self.LastName = userprofile.Data?.LastName
        self.Rating = userprofile.Data?.Rating
        self.Link = userprofile.Data?.Link
        self.WebSite = userprofile.Data?.WebSite
        self.Locale = userprofile.Data?.Locale
        self.Picture = userprofile.Data?.Picture
        self.Thumbnail = userprofile.Data?.Thumbnail
        self.ThumbnailURL = userprofile.Data?.ThumbnailURL
        self.IsActive = userprofile.Data?.IsActive
        self.IsDeleted = userprofile.Data?.IsDeleted
        self.IsWelcomeVisible = userprofile.Data?.IsWelcomeVisible
        self.IsVideoHelpVisible = userprofile.Data?.IsVideoHelpVisible
        self.IsDefault = userprofile.Data?.IsDefault
        self.Address = userprofile.Data?.Address
        self.OfficialName = userprofile.Data?.OfficialName
        self.Suffix = userprofile.Data?.Suffix
        self.Title = userprofile.Data?.Title
        self.JobTitle = userprofile.Data?.JobTitle
        self.PhoneNumber = userprofile.Data?.PhoneNumber
        self.PhoneContryCode = userprofile.Data?.PhoneContryCode
        self.OfficePhoneNumber = userprofile.Data?.OfficePhoneNumber
        self.OfficePhoneContryCode = userprofile.Data?.OfficePhoneContryCode
        self.CountryCode = userprofile.Data?.CountryCode
        self.UserSignatureID = userprofile.Data?.UserSignatureId
        self.Signature = userprofile.Data?.Signature
        self.Initials = userprofile.Data?.Initials
        self.SignatureDescription = userprofile.Data?.SignatureDescription
        self.UserSignatures = userprofile.Data?.UserSignatures
        self.ProfileStatus = userprofile.Data?.ProfileStatus
        self.Settings = userprofile.Data?.Settings
        self.CreatedBy = userprofile.Data?.CreatedBy
        self.UserType = userprofile.Data?.UserType
        self.BusinessName = userprofile.Data?.BusinessName
    }
}

extension UserProfileUpdate {
    func convertdocprocesstoDictonary(jsonstring: String) -> [String: Any]? {
        if let data = jsonstring.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            } catch let jsonerr {
                print("\(jsonerr.localizedDescription)")
            }
        }
        return nil
    }
}

extension UserProfileUpdate {
    func updateuserprofileData(userprofileupdate: UserProfileUpdate, completion:@escaping(Bool, String?) -> ()){
        ZorroHttpClient.sharedInstance.updateUserProfileDetails(userprofileupdate: userprofileupdate) { (success, errmsg) in
            
            if !success {
                completion(false, errmsg)
                return
            }
            completion(true, nil)
            return
        }
    }
}




