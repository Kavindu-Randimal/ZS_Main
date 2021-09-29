//
//  FallbackVerifyOTPRequest.swift
//  ZorroSign
//
//  Created by Chathura Ellawala on 7/3/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import Foundation

struct FallbackVerifyOTPRequest: Codable {
    
    var Otp: String?
    var UserId: String?
    
    init(Otp: String, UserId: String) {
        self.Otp = Otp
        self.UserId = UserId
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

//MARK: Request OTP With Secondary Email
extension FallbackVerifyOTPRequest {
    func verifyOtpFallback(verifyotprequest: FallbackVerifyOTPRequest, completion: @escaping(Bool) -> ()) {
        ZorroHttpClient.sharedInstance.verifyOtpFallback(verifyotprequest: verifyotprequest) { (requested) in
            completion(requested)
            return
        }
    }
}
