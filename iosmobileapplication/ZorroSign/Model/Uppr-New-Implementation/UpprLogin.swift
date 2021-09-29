//
//  UpprLogin.swift
//  ZorroSign
//
//  Created by Anuradh Caldera on 7/3/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import Foundation

struct UpprLogin: Codable {
    var StatusCode: Int?
    var Message: String?
    var `Data`: UpprData?
}

extension UpprLogin {
    func getupprloginDetails(upprcode: String, completion: @escaping(UpprLogin?, Bool, Int) -> ()) {
        ZorroHttpClient.sharedInstance.getuserUpprLoginDetails(upprcode: upprcode) { (upprdetails, err, status) in
            completion(upprdetails, err, status!)
            return
        }
    }
}

struct UpprData: Codable {
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
    var FirstName: String?
    var LastName: String?
    var Status: Int?
    var TimeStamp: String?
    var SessionType: Int?
    var IsRegistered: Bool?
    var IsActive: Bool?
    var RequestStatus: Int
}


