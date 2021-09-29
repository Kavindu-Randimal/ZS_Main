//
//  OraganizationstampUpload.swift
//  ZorroSign
//
//  Created by Anuradh Caldera on 5/15/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import Foundation

struct OrganizationstampUpload: Codable {
    
    var StampImage: String!
    var Id: Int? = 0
    
}

extension OrganizationstampUpload {
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

extension OrganizationstampUpload {
    func uploadorgStamp(orgstampupload: OrganizationstampUpload, completion: @escaping(Bool, String?) ->()) {
        
        ZorroHttpClient.sharedInstance.uploadorganizationstampImage(uploadorganizationstamp: orgstampupload) { (success, err) in
            completion(success, err)
        }
    }
}
