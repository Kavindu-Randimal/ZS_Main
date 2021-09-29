//
//  OragnizationStamp.swift
//  ZorroSign
//
//  Created by Anuradh Caldera on 5/8/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import Foundation

struct OrganizationStamp: Codable {
    
    var StatusCode: Int?
    var Mesage: String?
    var Data: StampData?
}

struct StampData: Codable {
    var Id: Int?
    var ProfileId: String?
    var OrganizationId: String?
    var StampImage: String?
}

//GET - stamp image
extension OrganizationStamp {
    func getstampImageString(completion: @escaping(String, Bool) -> ()) {
        ZorroHttpClient.sharedInstance.getOrganizationStamp { (organizationstamp, err) in
            
            if err {
                print("error with stamp")
                completion("", true)
                return
            }
            
            if let organizationStamp = organizationstamp {
                if let data = organizationStamp.Data {
                    ZorroTempData.sharedInstance.setStamp(stamp: data.StampImage!)
                    completion(data.StampImage!, false)
                    return
                }
                completion("", false)
                return
            }
        }
    }
}

