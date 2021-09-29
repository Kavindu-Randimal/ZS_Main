//
//  CreateProcess.swift
//  ZorroSign
//
//  Created by Anuradh Caldera on 8/28/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import Foundation

struct CreateProcess: Codable {
    var DocumentSetName: String?
    var IsSingleInstance: Bool?
    var IsUserPlaceHolderExists: Bool?
    var Steps: [Steps]?
    var WorkflowDefinitionId: String?
    
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

extension CreateProcess {
    func createWorkflowProcess(createprocess: CreateProcess, completion: @escaping(Bool, Int?) -> ()) {
        
        ZorroHttpClient.sharedInstance.createinitiatedProcesse(createprocess: createprocess) { (succss, instanceid) in
            completion(succss, instanceid)
            return
        }
        
    }
}
