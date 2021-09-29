//
//  CreateWorkflow.swift
//  ZorroSign
//
//  Created by Anuradh Caldera on 7/30/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import Foundation

struct CreateWorkflow: Codable {
    
    var Name: String?
    var Description: String?
    var IsSingleInstance: Bool = true
    var MainDocumentType: Int = 0
    var PdfPassword: String?
    
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

extension CreateWorkflow {
    func creatnewWorkFlow(createworkflow: CreateWorkflow, completion: @escaping(Int?) -> ()) {
        ZorroHttpClient.sharedInstance.createdocumentWorkFlow(createworkflow: createworkflow) { (workflowid) in
            completion(workflowid)
            return
        }
    }
}

