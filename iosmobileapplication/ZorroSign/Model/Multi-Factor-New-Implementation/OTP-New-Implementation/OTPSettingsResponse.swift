//
//  OTPSettingsResponse.swift
//  ZorroSign
//
//  Created by Anuradh Caldera on 10/11/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import Foundation

struct OTPSettingsResponse: Codable {
    var StatusCode: Int?
    var Message: String?
    var `Data`: OTPSettingsResponseData?
}

struct OTPSettingsResponseData: Codable {
    var OTPEnabled: Bool?
    var LoginOTPEnabled: Bool?
    var ApprovalOTPVerificationType: Int?
}
