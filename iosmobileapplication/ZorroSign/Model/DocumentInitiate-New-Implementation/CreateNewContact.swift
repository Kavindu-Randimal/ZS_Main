//
//  CreateNewContact.swift
//  ZorroSign
//
//  Created by Anuradh Caldera on 8/2/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import Foundation

struct CreateNewContact: Codable {
    
    var Company: String?
    var DisplayName: String?
    var Email: String?
    var Firstname: String?
    var JobTitle: String?
    var Lastname: String?
    var MiddleName: String?
    
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

extension CreateNewContact {
    func createNewContact(createcontact: CreateNewContact, completion: @escaping(Bool, ContactData?) -> ())  {
        ZorroHttpClient.sharedInstance.createnewcontactforCreateWorkflow(createcontact: createcontact) { (success, caontactdata) in
            completion(success, caontactdata)
            return
        }
    }
}
