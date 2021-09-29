//
//  OTPResendLogin.swift
//  ZorroSign
//
//  Created by Anuradh Caldera on 11/5/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import Foundation

struct OTPResendLogin: Codable {
    
    var UserId: String?
    var OtpType: Int?
    
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

//MARK : - Call to resend endpoint to get teh otp again
extension OTPResendLogin {
    func resendUserOTPLogin(otpresendlogin: OTPResendLogin, completion: @escaping(Bool) -> ()) {
        
        LoginAPI.sharedInstance.resendOTPForLogin(otpresendlogin: otpresendlogin) { (success) in
            
            completion(success)
            return
        }
    }
}
