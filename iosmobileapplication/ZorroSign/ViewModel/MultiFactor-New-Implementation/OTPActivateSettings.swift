//
//  OTPActivateSettings.swift
//  ZorroSign
//
//  Created by Anuradh Caldera on 10/11/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import Foundation

struct OTPActivateSettings {
    var _isotpActivated: Bool?
    var isotpactivatedLocally: Bool?
    var mobileNumber: String?
    var activateregistercellIndex: Int = 0
    var activateoptioncellIndex: Int = 0
    var _loginotpEnabled: Bool?
    var isloginotpEnabledLocally: Bool?
    var isapprovaltopEnabledLocally: Bool?
    var activateoptionIndex: Int?
    var countrydialcode: String?
    var countrycode: String?
    
    init(otpsettingsResponseData: OTPSettingsResponseData? = nil) {
        
        if otpsettingsResponseData != nil {
            let isotpenabled = otpsettingsResponseData!.OTPEnabled
            let loginotopenabled = otpsettingsResponseData!.LoginOTPEnabled
            let approvalverificationtype = otpsettingsResponseData!.ApprovalOTPVerificationType
            let otpnumber = ZorroTempData.sharedInstance.getOtpNumber()
            let userphone = ZorroTempData.sharedInstance.getPhoneNumber()
            
            
            self._isotpActivated = isotpenabled
            self.isotpactivatedLocally = isotpenabled
            
            if otpnumber != "" {
                self.mobileNumber = otpnumber
            } else {
                self.mobileNumber = userphone
            }
            
            if isotpenabled == nil {
                self.activateregistercellIndex = 0
                self.activateoptioncellIndex = 0
            }
            
            if let _isotpenabled = isotpenabled {
                if !_isotpenabled {
                    self.activateregistercellIndex = 0
                    self.activateoptioncellIndex = 0
                } else {
                    self.activateregistercellIndex = 4
                    self.activateoptioncellIndex = 1
                }
                
                switch approvalverificationtype {
                case 0,4:
                    self.isapprovaltopEnabledLocally = false
                    self.activateoptioncellIndex = 1
                case 1, 2, 3:
                    self.isapprovaltopEnabledLocally = true
                    self.activateoptioncellIndex = 2
                default:
                    self.isapprovaltopEnabledLocally = false
                    self.activateoptioncellIndex = 1
                }
                
            }
            
            self._loginotpEnabled = loginotopenabled
            self.isloginotpEnabledLocally = loginotopenabled
            self.activateoptionIndex = approvalverificationtype
        }
    }
}

//MARK: - Fetch OTP data from backend
extension OTPActivateSettings {
    func fetchotpSettings(completion: @escaping(OTPActivateSettings?) -> ()) {
        ZorroHttpClient.sharedInstance.getotpSettingsDetails { (otpsettingsData) in
            
            if otpsettingsData != nil {
                let _newotpactivateSettings = OTPActivateSettings(otpsettingsResponseData: otpsettingsData!)
                completion(_newotpactivateSettings)
                return
            }
            completion(nil)
            return
        }
    }
}

extension OTPActivateSettings {
    func approvalotpType(completion: @escaping(Int) -> ()) {
        fetchotpSettings { (otpsettingsData) in
            
            if let isotpactivated = otpsettingsData?._isotpActivated {
                if isotpactivated {
                    if let approvaltype = otpsettingsData?.activateoptionIndex {
                        switch approvaltype {
                        case 2,3:
                            completion(approvaltype)
                            return
                        default:
                            completion(0)
                            return
                        }
                    }
                    completion(0)
                    return
                }
                completion(0)
                return
            }
            completion(0)
            return
        }
    }
}

