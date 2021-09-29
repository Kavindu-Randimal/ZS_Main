//
//  OTPResendLoginResponse.swift
//  ZorroSign
//
//  Created by Anuradh Caldera on 11/5/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import Foundation

struct OTPResendLoginResponse: Codable {
    var StatusCode: Int?
    var Message: String?
    var Data: Bool?
    var IsSuccess: Bool?
    var Result: Bool?
}
