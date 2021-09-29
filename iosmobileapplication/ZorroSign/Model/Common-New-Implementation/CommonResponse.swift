//
//  OrganizationStampuplodResponse.swift
//  ZorroSign
//
//  Created by Anuradh Caldera on 5/16/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import Foundation

struct CommonUpdateResponse: Codable {
    
    var StatusCode: Int!
    var Message: String?
    var `Data`: Bool?
}

struct CommonUploadResponse: Codable {
    
    var StatusCode: Int!
    var Message: String?
    var `Data`: String?
}

struct CommonResponse: Codable {
    var StatusCode: Int!
    var Message: String?
}

struct CommonCreateworkflowResponse: Codable {
    var StatusCode: Int!
    var Message: String?
    var Data: Int?
}

struct CommonCreateworkflowUploadResponse: Codable {
    var StatusCode: Int!
    var Message: String?
    var Data: String?
}

struct CommonCreateContactResponse: Codable {
    var StatusCode: Int!
    var Message: String?
    var `Data`: ContactData?
}

struct CommonSaveWorkFlowResponse: Codable {
    var StatusCode: Int!
    var Message: String?
}

struct CommonCreateProcessResponse: Codable {
    var StatusCode: Int!
    var Message: String?
    var `Data`: Int?
}

struct CommonOTPOnboardResponse: Codable {
    var StatusCode: Int!
    var Message: String?
    var `Data`: Bool?
}

struct CommonOTPVerifyResponse: Codable {
    var StatusCode: Int!
    var Message: String?
    var `Data`: Bool?
}

struct CommmonOTPSaveSettingsResponse: Codable {
    var StatusCode: Int!
    var Message: String?
    var `Data`: Bool?
}

struct CommonOTPRequestResponse: Codable {
    var StatusCode: Int!
    var Message: String?
    var `Data`: Bool?
}

struct CommonOTPRequestwithPasswordResponse: Codable {
    var StatusCode: Int!
    var Message: String?
    var `Data`: Bool?
}

struct CommonOrganizationSettingsResponse: Codable {
    var StatusCode: Int!
    var Message: String?
    var `Data`: Bool?
}

struct CommontUpprUserRegisterResponse: Codable {
    var StatusCode: Int!
    var Message: String?
    var `Data`: Bool?
}

struct CommonPasswordlessStatusResponse: Codable {
    var KeyId: String?
}

struct CommonMultifactorSaveSettingsResponse: Codable {
    var StatusCode: Int?
    var Message: String?
//    var `Data`: Bool?
}


