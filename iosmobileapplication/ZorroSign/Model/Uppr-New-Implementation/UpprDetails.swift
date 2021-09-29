//
//  UpprDetails.swift
//  ZorroSign
//
//  Created by Anuradh Caldera on 7/4/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import Foundation

struct UpprDetails: Codable {
    
    var StatusCode: Int?
    var Message: String?
    var `Data`: UpprDetailsData?
}

extension UpprDetails {
    func getuserUpprDetails(upprcode: String, completion: @escaping(UpprDetails?, Bool) -> ()) {
        ZorroHttpClient.sharedInstance.getuserUpprDetails(upprcode: upprcode) { (upprdetails, err) in
            completion(upprdetails, err)
            return
        }
    }
}

struct UpprDetailsData: Codable {
    
    var Id: Int?
    var UPPRId: String?
    var ReceiverEmail: String?
    var ProcessId: Int?
    var ExpireDate: String?
    var UPPRStatus: Int?
    var UPPRType: Int?
    var MetaData: String?
    
}
