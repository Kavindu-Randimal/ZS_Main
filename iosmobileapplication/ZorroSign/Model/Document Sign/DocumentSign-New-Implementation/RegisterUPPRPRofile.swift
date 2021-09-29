//
//  RegisterUPPRPRofile.swift
//  ZorroSign
//
//  Created by Anuradh Caldera on 2/7/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import Foundation

struct RegisterUPPRProfile: Codable {
    var UserProfile: UserData?
    var Password: String?
}

extension RegisterUPPRProfile {
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

extension RegisterUPPRProfile {
    func registerupprUserProfile(registerupprprofile: RegisterUPPRProfile, completion: @escaping(Bool) -> ()) {
        ZorroHttpClient.sharedInstance.registerUpprUserDetails(registeruuprprofile: registerupprprofile) { (success) in
            
            completion(success)
            return
        }
    }
}
