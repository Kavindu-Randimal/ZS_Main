//
//  FallbackOTPRequest.swift
//  ZorroSign
//
//  Created by Chathura Ellawala on 7/3/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import Foundation

struct FallbackOTPRequest: Codable {
    
    var SecondaryEmail: String?
    var UserId: String?
    
    init(SecondaryEmail: String, UserId: String) {
        self.SecondaryEmail = SecondaryEmail
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
extension FallbackOTPRequest {
    func requestuserotpWithSecondaryEmail(otprequestwithemail: FallbackOTPRequest, completion: @escaping(Bool) -> ()) {
        ZorroHttpClient.sharedInstance.requestuserotpWithSecondaryEmail(requestotpwithemail: otprequestwithemail) { (requested) in
            completion(requested)
            return
        }
    }
}
