//
//  UserLogin.swift
//  ZorroSign
//
//  Created by Anuradh Caldera on 10/18/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import Foundation

struct UserLogin: Codable {
    var StatusCode: Int?
    var Message: String?
    var `Data`: UserLoginData?
}

struct UserLoginData: Codable {
    var Locale: String?
    var UserId: String?
    var SPassId: String?
    var UserType: Int?
    var ProfileId: String?
    var ProfileCompletionStatus: Int?
    var OrganizationId: String?
    var UserName: String?
    var ServiceToken: String?
    var ServiceTokenExpiryDate: String?
    var CreatedDateTime: String?
    var ModifieddDateTime: String?
    var Status: Int?
    var TimeStamp: String?
    var Permissions: [String]?
    var Roles: [UserLoginDataRoles]?
    var SessionType: Int?
    var IsRegistered: Bool?
    var IsActive: Bool?
    var RequestStatus: Int?
    var IsMFAForcedToEnable: Bool?
    var IsOrganizationMFAEnabledForUsers: Bool?
    var PasswordExpiryDate: String?
    var PasswordExpiryWarning: Bool?
    var Subscription: SubscriptionDetails?
}

struct UserLoginDataRoles: Codable {
    var RoleId: Int?
    var Name: String?
    var IsDefault: Bool?
}

struct SubscriptionDetails: Codable {
    var ProfileId: String?
    var SubscriptionType: Int?
    var SubscriptionPlan: Int?
    var IsSubscriptionActive: Bool?
    var ExpireDateTime: String?
    var AvailableDocumentSetCount: Int?
    var TotalDocumentSetCount: Int?
}

