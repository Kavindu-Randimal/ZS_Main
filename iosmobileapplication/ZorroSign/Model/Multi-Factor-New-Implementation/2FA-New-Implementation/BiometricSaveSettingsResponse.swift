//
//  BiometricSaveSettingsResponse.swift
//  ZorroSign
//
//  Created by CHATHURA ELLAWALA on 7/15/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import Foundation

struct BiometricSaveSettingsResponse: Codable {
    var StatusCode: Int?
    var Message: String?
    var `Data`: BiometricSettings?
}

struct BiometricSettings: Codable {
    
    var TwoFAType: Int?
    var LoginVerificationType: Int?
    var ApprovalVerificationType: Int?
    var IsBiometricEnabled: Bool?
    var BiometricFallbackOptions: BiometricFallbackOptionsOnboarding?
    var BiometricFallbackAnswers: [BiometricFallbackAnswersOnboarding]?
}

struct BiometricFallbackOptionsOnboarding: Codable {
    
    var IsFallbackEnable: Bool?
    var `Type`: Int?
    var IsAccountLock: Bool?
    var FallbackOptions: [String]?
}

struct BiometricFallbackAnswersOnboarding: Codable {
    
    var `Type`: Int?
    var Email: String?
    var OTP: Int?
    var Question: String?
    var Answer: String?
}


