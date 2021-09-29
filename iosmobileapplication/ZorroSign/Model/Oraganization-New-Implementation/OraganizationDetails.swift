//
//  OraganizationDetails.swift
//  ZorroSign
//
//  Created by Anuradh Caldera on 5/29/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import Foundation

// MARK: - OrganizationDetails
struct OrganizationDetails: Codable {
    var StatusCode: Int?
    var Message: String?
    var `Data`: OraganizationData?
}

extension OrganizationDetails {
    func geturerorganizationDetails(completion: @escaping(OrganizationDetails?) -> ()) {
        ZorroHttpClient.sharedInstance.getOrganizationDetails { (organizationdetails) in
            completion(organizationdetails)
        }
    }
}

// MARK: - DataClass
struct OraganizationData: Codable {
    var Organization: Organization?
    var OrganizationContact: OrganizationContact?
    var isUpdatingOtherSide: Bool?
}

// MARK: - Organization
struct Organization: Codable {
    var OrganizationId, UserId, LegalName, CountryCode: String?
    var TradeLicenseNumber, TradeLicenseExpiryDate, DBA, Logo: String?
    var LogoURL, Stamp, Size: String?
    var BusinessCategoryID: Int?
    var CreatedBy, ModifiedBy: String?
}

// MARK: - OrganizationContact
struct OrganizationContact: Codable {
    var UserID, OrganizationID, AddressLine1, AddressLine2: String?
    var ZipCode, StateCode, City, County: String?
    var Country, CountryCode, Area, Address: String?
    var PhoneNumber, MobileNumber, Email, WebSite: String?
    var CreatedBy, ModifiedBy: String?
}


