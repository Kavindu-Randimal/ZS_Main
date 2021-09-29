//
//  GetDocumentDetails.swift
//  ZorroSign
//
//  Created by Anuradh Caldera on 7/2/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import Foundation

struct GetDocumentDetails: Codable {
    var QRCodeData: String!
    var Request: Int!
    
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

extension GetDocumentDetails {
    func requestdoctrailPermission(getdocdetails: GetDocumentDetails, completion: @escaping(Bool, String?, Int) -> ()) {
        AuditTrailAPI.sharedInstance.requestPermissionforDocTrail(getdocumentdetails: getdocdetails) { (success, messsage, statuscode) in
            completion(success, messsage, statuscode!)
            return
        }
    }
}
