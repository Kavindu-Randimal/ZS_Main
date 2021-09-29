//
//  StepPassword.swift
//  ZorroSign
//
//  Created by CHATHURA ELLAWALA on 10/7/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import Foundation

struct StepPassword: Codable {
    let ProcessId: Int?
    let StepPassword: String?
    
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

extension StepPassword {
    func checkStepPassword(stepPassword: StepPassword, completion: @escaping(Bool, String?) -> ()) {
        
        ZorroHttpClient.sharedInstance.checkStepPassword(stepPassword: stepPassword) { (res, err) in
            completion(res, err)
            return
        }
    }
}


