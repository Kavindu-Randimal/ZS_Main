//
//  CheckStepPassword.swift
//  ZorroSign
//
//  Created by CHATHURA ELLAWALA on 10/7/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import Foundation

struct CheckStepPassword: Codable {
    let statusCode: Int?
    let message: String?
    let data: Bool?

    enum CodingKeys: String, CodingKey {
        case statusCode = "StatusCode"
        case message = "Message"
        case data = "Data"
    }
}

