//
//  OTPVerify.swift
//  ZorroSign
//
//  Created by Anuradh Caldera on 10/12/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import Foundation

struct OTPVerify: Codable {
    
    var UserId: String?
    var Otp: Int?
    var MobileNumber: String?
    
    init(userid: String? = nil, otpvalue: Int? = nil, mobilenumber: String? = nil) {
        self.UserId = userid
        self.Otp = otpvalue
        self.MobileNumber = mobilenumber
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

//MARK: - Request otp
extension OTPVerify {
    func requestOTP(completion: @escaping(Bool, Bool) -> ()) {
        LoginAPI.sharedInstance.requestOTPFromApi { (requested, otpissue) in
            completion(requested, otpissue)
            return
        }
    }
}

//MARK: - Veriifyotp
extension OTPVerify {
    func verifyuserOTP(otpverify: OTPVerify, completion: @escaping(Bool) -> ()) {
        LoginAPI.sharedInstance.verifyuserwithOntimePassword(otpverify: otpverify) { (verified) in
            completion(verified)
            return
        }
    }
}
