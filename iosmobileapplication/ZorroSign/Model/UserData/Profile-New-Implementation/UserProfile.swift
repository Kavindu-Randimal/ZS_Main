//
//  UserProfile.swift
//  ZorroSign
//
//  Created by Anuradh Caldera on 5/22/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import Foundation

// MARK: - UserProfile
struct UserProfile: Codable {
    var StatusCode: Int?
    var Message: String?
    var `Data`: UserData?
}

extension UserProfile {
    func getuserprofileData(completion: @escaping(UserProfile?, Bool) -> ()) {
        let profileid = ZorroTempData.sharedInstance.getProfileId()
        ZorroHttpClient.sharedInstance.getuerProfileDetails(profileid: profileid) { (userprofile, err) in
            if err {
                completion(nil, err)
                return
            }
            completion(userprofile!, err)
        }
    }
}

extension UserProfile {
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

// MARK: - DataClass
struct UserData: Codable {
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
    var JobTitle, PhoneNumber, PhoneContryCode, OfficePhoneNumber, OfficePhoneContryCode, OTPMobileNumber: String?
    var UserSignatureId: Int?
    var Signature, Initials: String?
    var SignatureDescription: SignatDescription?
    var UserSignatures: [UserSignature]?
    var ProfileStatus: Int?
    var Settings: UserSettings?
    var CreatedBy, ModifiedBy: String?
    var UserType: Int?
    var IsMerged: Bool?
    var BusinessName: String?
    var TimeZoneDetails: TimeZoneDetails?
    var IsSsnAvailable: Bool?
}

// MARK: - Settings
struct UserSettings: Codable {
    var signatureImage, initialImage, signatureType, initialType: String?
    var signaturetext, initialtext, editProfilesignFont, editProfilesignFontsize: String?
    var editProfileinitFont, editProfileinitFontsize: String?
    var signaturePath, initialPath: [Path]?
    var signatureIsolatedPoints, initialIsolatedPoints: [Control1]?
    var penWidth: Double?
    var penColor: String?
    var penColorSliderPosition, signatureWidth, signatureHeight, initialWidth: Int?
    var initialHeight: Int?
}

// MARK: - Path
struct Path: Codable {
    var startPoint, control1, control2, endPoint: Control1?
}

// MARK: - Control1
struct Control1: Codable {
    var x, y: Double?
}

// MARK: - SignatureDescription
struct SignatDescription: Codable {
    var DescriptionKey, DescriptionText, DescriptionValue, Reason: String?
}

// MARK: - TimeZoneDetails
struct TimeZoneDetails: Codable {
    var BaseUTCOffset, DisplayName, DtandardName: String?
    var SupportsDaylightSavingTime: Bool?
}

// MARK: - UserSignature
struct UserSignature: Codable {
    var UserSignatureId: Int?
    var Signature, Initials: String?
    var SignatureDescription: SignatDescription?
    var Settings: UserSettings?
    var IsDefault, IsDeleted: Bool?
}


