//
//  OTPSaveSettings.swift
//  ZorroSign
//
//  Created by Anuradh Caldera on 10/12/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import Foundation

struct OTPSaveSettings: Codable {
    var OTPEnabled: Bool?
    var LoginOTPEnabled: Bool?
    var ApprovalOTPVerificationType: Int?
    
    init(otpactivatesettings: OTPActivateSettings) {
        self.OTPEnabled = otpactivatesettings.isotpactivatedLocally
        self.LoginOTPEnabled = otpactivatesettings.isloginotpEnabledLocally
        self.ApprovalOTPVerificationType = otpactivatesettings.activateoptionIndex
    }
    
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

//MARK: - Save Changed OTP Settings
extension OTPSaveSettings {
    func saveotpuserSettings(otpsavesettings: OTPSaveSettings, completion: @escaping(Bool) -> ()) {
        ZorroHttpClient.sharedInstance.saveuserOnetimePasswordSettings(otpsavesettings: otpsavesettings) { (saved) in
            completion(saved)
            return
        }
    }
}
