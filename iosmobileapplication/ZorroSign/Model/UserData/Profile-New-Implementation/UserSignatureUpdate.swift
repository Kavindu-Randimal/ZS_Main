//
//  UserSignatureUpdate.swift
//  ZorroSign
//
//  Created by CHATHURA ELLAWALA on 2021-01-21.
//  Copyright © 2021 Apple. All rights reserved.
//

import Foundation

struct UserSignatureUpdate: Codable {
    var ProfileId: String?
    var PinCode: String?
    var UserSignatures: [UserSignature]?
}

extension UserSignatureUpdate {
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

extension UserSignatureUpdate {
    func updateusersignatureData(usersignatureupdate: UserSignatureUpdate, completion:@escaping(Bool, String?, Int) -> ()){
        ZorroHttpClient.sharedInstance.updateUserSignatureDetails(usersignatureData: usersignatureupdate) { (success, errmsg, statuscode) in
            
            if !success {
                completion(false, errmsg, statuscode)
                return
            }
            completion(true, nil, statuscode)
            return
        }
    }
}
