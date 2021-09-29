//
//  MultifactorSettingsViewModel.swift
//  ZorroSign
//
//  Created by Anuradh Caldera on 2/21/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import Foundation

struct MultifactorSettingsViewModel {
    
    var otpSwitch: Bool = false
    var biometricSwitch: Bool = false
    var loginSwitch: Bool = false
    var approvalSwitch: Bool = false
    var approvalOptionIndex: Int?
    var numberofRows: Int = 0
    var subStep: Int?
    var mobilenNumber: String?
    var twoFAType: Int?
    var twoFATypeLocal: Int?
    var loginVerificationType: Int?
    var approvalVerificationType: Int?
    var isBiometricEnabled: Bool?
    var countryDialcode: String?
    var countryCode: String?
    var recoveryOptionSelected: Int = 0
    var recoveryOptionType: Int = 0
    var isfallbackEnable: Bool = false
    var recoveryoptionsubType: Int?
    
    init(multifactorsettingsresponsedata: MultifactorSettingsResponseData) {
        
        guard let twofatype = multifactorsettingsresponsedata.TwoFAType,
            let loginverificationtype = multifactorsettingsresponsedata.LoginVerificationType,
            let approvalverificationtype = multifactorsettingsresponsedata.ApprovalVerificationType,
            let isbiometricenabled = multifactorsettingsresponsedata.IsBiometricEnabled else{
                return
        }
        
        if let recoveryOptionType = multifactorsettingsresponsedata.BiometricFallbackStatus?.Type,
            let isfallbackEnable = multifactorsettingsresponsedata.BiometricFallbackStatus?.IsFallbackEnable {
            self.recoveryOptionType = recoveryOptionType
            self.isfallbackEnable = isfallbackEnable
            
            if self.recoveryOptionType == 1 {
                self.recoveryoptionsubType = 0
            }
        }
        
        self.twoFAType = twofatype
        self.twoFATypeLocal = twofatype
        self.loginVerificationType = loginverificationtype
        self.approvalVerificationType = approvalverificationtype
        self.isBiometricEnabled = isbiometricenabled
        
        switch twofatype {
        case 0:
            //Disabled
            otpSwitch = false
            biometricSwitch = false
            numberofRows = 1
            return
        case 1:
            //OTP
            otpSwitch = true
            biometricSwitch = false
            numberofRows = 2
            subStep = 0
            
            let otpnumber = ZorroTempData.sharedInstance.getOtpNumber()
            let userphone = ZorroTempData.sharedInstance.getPhoneNumber()
            (otpnumber != "") ? (mobilenNumber = otpnumber) : (mobilenNumber = userphone)
            (loginverificationtype == 2) ? (loginSwitch = true) : (loginSwitch = false)
            switch approvalverificationtype {
            case 2, 3:
                approvalSwitch = true
                (approvalverificationtype == 2) ? (approvalOptionIndex = 1) : (approvalOptionIndex = 2)
            default:
                approvalSwitch = false
            }
            return
        case 2:
            //Biometric
            otpSwitch = false
            biometricSwitch = true
            numberofRows = 2
            
            switch recoveryOptionSelected {
            case 0:
                (loginverificationtype == 3) ? (loginSwitch = true) : (loginSwitch = false)
                switch approvalverificationtype {
                case 4, 5:
                    approvalSwitch = true
                    (approvalverificationtype == 4) ? (approvalOptionIndex = 1) : (approvalOptionIndex = 2)
                    subStep = 1
                default:
                    approvalSwitch = false
                    subStep = 0
                }
            default:
                switch recoveryOptionType {
                case 1:
                    recoveryoptionsubType = 0
//                case 2:
//                    recoveryoptionsubType = 2
                default:
                    //subStep = 0
                    return
                }
                return
            }
            
            return
        default:
            return
        }
    }
    
}

struct SecurityQuestion {
    var questionModel: FallbackQuestionsWithSelect?
    var answerId: String?
    var answer: String?
    var userId: String?
}
