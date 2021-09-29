//
//  OTPVerifyLogin.swift
//  ZorroSign
//
//  Created by Anuradh Caldera on 10/18/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import Foundation

struct OTPVerifyLogin: Codable {
    
    var Username: String?
    var Otp: Int?
    var ClientId: String?
    var ClientSecret: String?
    
    
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

//MARK: Verify user with otp -> Login
extension OTPVerifyLogin {
    func verifyuserloginwithOTP(otpverifylogin: OTPVerifyLogin, completion: @escaping(UserLoginData?, Int?) -> ()) {
        LoginAPI.sharedInstance.verifyloginOTP(otpverifylogin: otpverifylogin) { (logindata, statusCode)  in
            completion(logindata, statusCode)
            return
        }
    }
}
