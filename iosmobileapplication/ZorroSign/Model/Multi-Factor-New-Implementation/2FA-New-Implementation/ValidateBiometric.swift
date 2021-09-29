//
//  ValidateBoimetric.swift
//  
//
//  Created by Anuradh Caldera on 2/11/20.
//

import Foundation

struct ValidateBiometric: Codable {
    
    var UserId: String?
    var CorrelationId: String?
    var IsValidate: Bool?
    var Signature: String?
    var KeyId: String?
}

extension ValidateBiometric {
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

extension ValidateBiometric {
    func verifyuserWithBiometrics(validatebiometrics: ValidateBiometric, completion: @escaping(Bool) ->()) {
        
        ZorroHttpClient.sharedInstance.validateUserWithBiometricVerification(validatebiometric: validatebiometrics) {
            print("completed")
        }
        return
    }
}
