//
//  PasswordlessAuthentication.swift
//  ZorroSign
//
//  Created by Anuradh Caldera on 11/22/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import Foundation

struct PasswordlessAuthentication: Codable {
    
    var UserId: String?
    var SessionId: String?
    var DeviceId: String?
    var Signature: String?
    
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

extension PasswordlessAuthentication {
    func userAuthenticateWithQR(passwordlessauthentication: PasswordlessAuthentication, completion:@escaping(Bool) -> ()) {
        
        LoginAPI.sharedInstance.passwordlessUserAuthentication(passwordlessauth: passwordlessauthentication) { (success) in
            completion(success)
            return
        }
        
    }
}
