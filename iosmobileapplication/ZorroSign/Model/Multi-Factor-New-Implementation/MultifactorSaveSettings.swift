//
//  MultifactorSaveSettings.swift
//  ZorroSign
//
//  Created by Anuradh Caldera on 2/21/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import Foundation

struct MultifactorSaveSettings: Codable {
    
    var TwoFAType: Int?
    var LoginVerificationType: Int?
    var ApprovalVerificationType: Int?
    var IsBiometricEnabled: Bool?
    var BiometricFallbackOptions: BiometricFallbackOptions?
    var BiometricFallbackAnswers: [BiometricFallbackAnswers] = []
    
    init(multifactorsettingsviewmodel: MultifactorSettingsViewModel) {
        self.TwoFAType = multifactorsettingsviewmodel.twoFATypeLocal
        self.LoginVerificationType = multifactorsettingsviewmodel.loginVerificationType
        self.ApprovalVerificationType = multifactorsettingsviewmodel.approvalVerificationType
        self.IsBiometricEnabled = multifactorsettingsviewmodel.isBiometricEnabled
    }
}

struct BiometricFallbackAnswers: Codable {
    
    var `Type`: Int?
    var Email: String?
    var OTP: Int?
    var Question: String?
    var Answer: String?
}

extension MultifactorSaveSettings {
    func convertdocprocesstoDictonary(jsonstring: String) -> [String: Any]? {
        if let data = jsonstring.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            } catch let jsonerr {
                print("\(jsonerr.localizedDescription)")
            }
        }
        return nil
    }
}

extension MultifactorSaveSettings {
    func postMultifactorSettings(multifactorsettings: MultifactorSaveSettings, completion: @escaping(Bool) -> ()) {
        ZorroHttpClient.sharedInstance.savemltifactorSettingsDetails(multifactorsettings: multifactorsettings) { (success) in
            
            completion(success)
            return
        }
    }
}

//MARK: - Save Biometric Settings
extension MultifactorSaveSettings {
    func postBiometricSettings(multifactorsettings: MultifactorSaveSettings, completion: @escaping(BiometricSettings?, Int, String) -> ()) {
        ZorroHttpClient.sharedInstance.postBiometricSettingsDetails(multifactorsettings: multifactorsettings) { (biometricsettings, statuscode, message) in
            
            
            completion(biometricsettings, statuscode, message)
            return
        }
    }
}
