//
//  PasswordlessOnboarding.swift
//  ZorroSign
//
//  Created by Anuradh Caldera on 11/19/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import Foundation

struct PasswordlessOnboarding: Codable {
    
    var ID: String?
    var Uuid: String?
    var PushToken: String?
    var DeviceType: String?
    var DeviceModel: String?
    var PublicKey : String?
    var KeyId: String?
    var DeviceId: String?
    var Csr: String?
    
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

//MARK: - onboard user for passwordless
extension PasswordlessOnboarding {
    func onboardUserForPasswordless(passwordlessonboarding: PasswordlessOnboarding, completion: @escaping(Bool) -> ()) {
        
        ZorroHttpClient.sharedInstance.passwordlessUserOnboard(pwdlessOnbarding: passwordlessonboarding) { (success) in
            completion(success)
            return
        }
    }
}
