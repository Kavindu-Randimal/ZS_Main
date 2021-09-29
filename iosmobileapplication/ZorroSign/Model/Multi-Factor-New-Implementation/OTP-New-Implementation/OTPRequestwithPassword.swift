//
//  OTPRequestwithPassword.swift
//  ZorroSign
//
//  Created by Anuradh Caldera on 10/16/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import Foundation

struct OTPRequestwithPassword: Codable {
    var IsSingleInstance: Bool? = false
    var Password: String?
    
    init(issingleInstance: Bool, password: String) {
        self.IsSingleInstance = issingleInstance
        self.Password = password
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

//MARK: Request OTP With Password
extension OTPRequestwithPassword {
    func requestuserotpWithPassword(otprequestwithpassword: OTPRequestwithPassword, completion: @escaping(Bool, Bool) -> ()) {
        ZorroHttpClient.sharedInstance.requestOTPWithPassword(requestotpwithpassword: otprequestwithpassword) { (requested, otpissue) in
            completion(requested, otpissue)
            return
        }
    }
}
