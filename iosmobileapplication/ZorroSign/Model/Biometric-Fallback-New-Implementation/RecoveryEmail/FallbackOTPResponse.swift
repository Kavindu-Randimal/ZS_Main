//
//  FallbackOTPResponse.swift
//  ZorroSign
//
//  Created by Chathura Ellawala on 7/3/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import Foundation

struct FallbackOTPResponse: Codable {
    var StatusCode: Int?
    var Message: String?
    var `Data`: Bool?
}
