//
//  GetWorkflow.swift
//  ZorroSign
//
//  Created by Anuradh Caldera on 8/8/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import Foundation

struct GetWorkflow: Codable {
    
    var StatusCode: Int?
    var Message: String?
    var `Data`: GetWorkflowData?
}

extension GetWorkflow {
    func getworkflowdatawidhWorkflowID(workflowid: Int, completion:@escaping(GetWorkflowData?) ->()) {
        
        let wofkflowidstring = String(workflowid)
        ZorroHttpClient.sharedInstance.getworkflowDetails(workflowid: wofkflowidstring) { (getworkflowresponse) in
            
            guard let responsedata = getworkflowresponse?.Data else {
                completion(nil)
                return
            }
            completion(responsedata)
            return
        }
    }
}

extension GetWorkflow {
    func downloadworkflowmergedPDF(workflowid: Int, objectid: String, documentname: String, completion: @escaping(URL?) -> ()) {
        
        let workflowidstring = String(workflowid)
        ZorroHttpClient.sharedInstance.downlaodworkflowPDF(workflowid: workflowidstring, objectid: objectid, documentname: documentname) { (documenturl) in
            completion(documenturl)
            return
        }
    }
}

struct GetWorkflowData: Codable {
    let CreationMode: Int?
    let Id: Int?
    let Name: String?
    let Description: String?
    let Documents: [GetWorkflowDocument]?
    let MultiUploadDocumentInfo: [GetWorkflowMultiuplodDocumentInfo]?
}

struct GetWorkflowDocument: Codable {
    
    let Id: Int?
    let ObjectId: String?
    let DocType: Int?
    let Name: String?
    let OriginalName: String?
    let IsDeletable: Bool
    let CreatedBy: Int
}

struct GetWorkflowMultiuplodDocumentInfo: Codable {
    
    let OrderNumber: Int?
    let Id: Int?
    let ObjectId: String?
    let DocType: Int?
    let CustomName: String?
    let OriginalName: String?
    let IsDeleted: Bool
    let IsDeletable: Bool
}
