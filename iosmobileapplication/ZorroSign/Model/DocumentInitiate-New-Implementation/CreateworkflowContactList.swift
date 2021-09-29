//
//  CreateworkflowContactList.swift
//  ZorroSign
//
//  Created by Anuradh Caldera on 8/1/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import Foundation

struct CreateworkflowContactList: Codable {
    
    var StatusCode: Int!
    var Message: String!
    var `Data`: [ContactData]?
}

extension CreateworkflowContactList {
    func getContactList(completion: @escaping([ContactData]?) -> ()) {
        ZorroHttpClient.sharedInstance.getcontactlistforCreateWorkflow { (contactlist) in
            completion(contactlist)
            return
        }
    }
}
