//
//  BiometricsWrapper.swift
//  ZorroSign
//
//  Created by Anuradh Caldera on 11/21/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import Foundation
import UIKit
import LocalAuthentication

class BiometricsWrapper {
    public enum BiometricType {
        case none
        case touch
        case face
    }
}

//MARK: - Get Biometric Type
extension BiometricsWrapper {
    
    func getDeviceBiometricType() -> BiometricType {
        let authConetext = LAContext()
        let _ = authConetext.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil)
        
        
        switch(authConetext.biometryType) {
        case .none:
            return BiometricType.none
        case .touchID:
            return BiometricType.touch
        case .faceID:
            return BiometricType.face
        }
    }
}

//MARK: Check for user enrollment
extension BiometricsWrapper {
    
    //MARK: Check for enrollment
    func checkBiometricEnrollement() -> Bool {
        var hasEnrolled: Bool = false;
        let authContext = LAContext()
        var error: NSError?
        let biometricstype = getDeviceBiometricType()
        
        switch biometricstype {
        case .touch, .face:
            if authContext.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
                hasEnrolled = true
            } else {
                if error != nil {
                    if authContext.canEvaluatePolicy(.deviceOwnerAuthentication, error: &error) {
                        hasEnrolled = true
                    } else {
                        hasEnrolled = false
                    }
                }
            }
        default:
            if authContext.canEvaluatePolicy(.deviceOwnerAuthentication, error: &error) {
                hasEnrolled = true
            } else {
                if error != nil {
                    hasEnrolled = false
                }
            }
        }
        return hasEnrolled
    }
}

//MARK: - Navigate User To Settings
extension BiometricsWrapper {
    func navigateToDeviceSettigns() {
        guard let profileUrl = URL(string: UIApplication.openSettingsURLString) else { return }
        if UIApplication.shared.canOpenURL(profileUrl) {
            UIApplication.shared.open(profileUrl, options: [:], completionHandler: nil)
        }
        return
    }
}

//MARK:-  Authenticate Usere
extension BiometricsWrapper {
    
    func authenticateWithBiometric(completion: @escaping(Bool?, String?) -> ()) {
        
        DispatchQueue.main.async {
            let _authenticationContext = LAContext()
            _authenticationContext.localizedFallbackTitle = ""
            let _biometricType = self.getDeviceBiometricType()
            let _biometricTypeString = String(describing: _biometricType)
            var errormessage = ""
            
            switch _biometricType {
            case .none:
                _authenticationContext.evaluatePolicy(.deviceOwnerAuthentication, localizedReason: "Please Enter Device Passcode to Continue", reply: { (success, error) in
                    
                    if success {
                        completion(success, nil)
                        return
                    } else {
                        switch error!._code {
                        case LAError.authenticationFailed.rawValue:
                            errormessage = "Authentication Failed, Unabele to Autenticate the User"
                            break
                        case LAError.systemCancel.rawValue:
                            errormessage = "Authentication Cancelled By The Sytem"
                            break
                        case LAError.userCancel.rawValue:
                            errormessage = "Authentication Cancelled By The User"
                            break
                        case LAError.userFallback.rawValue:
                            errormessage = "User Selected The Fallback Option"
                            break
                        default:
                            errormessage = "Authentication Failed"
                            break
                        }
                        completion(false, errormessage)
                        return
                    }
                })
            default:
                _authenticationContext.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: "Please verify your \(_biometricTypeString) ID to continue", reply: { (success, error) in
                    
                    if success {
                        completion(true, nil)
                        return
                    } else {
                        _authenticationContext.evaluatePolicy(.deviceOwnerAuthentication, localizedReason: "Please Enter Device Passocde To Continue") { (success, error) in
                            
                            if success {
                                completion(success, nil)
                                return
                            }
                            
                            switch error!._code {
                            case LAError.authenticationFailed.rawValue:
                                errormessage = "Authentication Failed, Unabele to Autenticate the User"
                                break
                            case LAError.systemCancel.rawValue:
                                errormessage = "Authentication Cancelled By The Sytem"
                                break
                            case LAError.userCancel.rawValue:
                                errormessage = "Authentication Cancelled By The User"
                                break
                            case LAError.userFallback.rawValue:
                                errormessage = "User Selected The Fallback Option"
                                break
                            default:
                                errormessage = "Authentication Failed"
                                break
                            }
                            completion(false, errormessage)
                            return
                        }
                        return
                    }
                })
            }
        }
    }
}
