//
//  ContactData.swift
//  ZorroSign
//
//  Created by Mathivathanan on 8/18/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import Foundation

struct ContactData: Codable {
    var IdNum: Int?
    var Id: String?
    var ContactProfileId: String?
    var Name: String?
    var Description: String?
    var Email: String?
    var DepartmentName: String?
    var `Type`: Int?
    var Thumbnail: String?
    var UserCount: Int?
    var IsZorroUser: Bool?
    var UserType: Int?
    var Company: String?
    var JobTitle: String?
    var IsLocked: Bool?
    var IsSubscribed: Bool?
    var GroupContactEmails: String?
    var FullName: String?
    var ContactId: Int?
    var ProfileId: String?
}
