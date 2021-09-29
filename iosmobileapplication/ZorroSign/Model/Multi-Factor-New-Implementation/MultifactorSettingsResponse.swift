//
//  MultifactorSettingsResponse.swift
//  ZorroSign
//
//  Created by Anuradh Caldera on 2/20/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import Foundation

struct MultifactorSettingsResponse: Codable {
    
    var StatusCode: Int?
    var Message: String?
    var `Data`: MultifactorSettingsResponseData?
}

struct MultifactorSettingsResponseData: Codable {
    
    var TwoFAType: Int?
    var LoginVerificationType: Int?
    var ApprovalVerificationType: Int?
    var IsBiometricEnabled: Bool?
    var BiometricFallbackStatus: BiometricFallbackStatus?
    var BiometricFallbackOptions: BiometricFallbackOptions?
}

struct BiometricFallbackStatus: Codable {
    
    var IsFallbackEnable: Bool?
    var `Type`: Int?
}

struct BiometricFallbackOptions: Codable {
    
    var IsFallbackEnable: Bool?
    var `Type`: Int?
    var IsAccountLock: Bool?
}

extension MultifactorSettingsResponse {
    func getuserMultifactorSettings(completion: @escaping(MultifactorSettingsResponseData?) -> ()) {
        
        ZorroHttpClient.sharedInstance.getmultifactorSettingsDetails { (multifactorresponse) in
            if multifactorresponse != nil {
                completion(multifactorresponse)
                return
            }
        }
    }
}
