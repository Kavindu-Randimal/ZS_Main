//
//  GetDocumentTrail.swift
//  ZorroSign
//
//  Created by Anuradh Caldera on 6/25/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import Foundation

struct GetDocumentTrail: Codable {
    
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

extension GetDocumentTrail {
    func getdocumenttrailDetails(getdoctrail: GetDocumentTrail!, completion: @escaping(DocumentTrailDetails?, Bool, Int?) -> ()) {
        AuditTrailAPI.sharedInstance.getDocumentTrailDetails(getdocumenttrail: getdoctrail) { (doctraildetails, err, statuscode) in
            if err {
                completion(nil, true, statuscode)
                return
            }
            
            completion(doctraildetails, false, statuscode)
            return
        }
    }
}

extension GetDocumentTrail {
    func downloadSpecificFile(processid: String, objectid: String, completion: @escaping(String?, Bool) -> ()) {
        
        AuditTrailAPI.sharedInstance.downloadfileWithUrl(processID: processid, objectID: objectid, documentID: "-1") { (filename, err) in
           completion(filename, err)
            return
        }
    }
}

//MARK: - Download files new
extension GetDocumentTrail {
    func downloadSpecificFileNew(processid: String, objectid: String, docname: String, completion: @escaping(String?, Bool) -> ()) {
        
        AuditTrailAPI.sharedInstance.downloadfileWithUrlNew(processid: processid, objectId: objectid, docname: docname) { (filename, err) in
            completion(filename, err)
            return
        }
    }
}

//MARK: - Download Digital Certificate
extension GetDocumentTrail {
    func downloadDigitalCertificate(processid: Int, completion: @escaping(String?, Bool) -> ()) {
        
        AuditTrailAPI.sharedInstance.downloadDigitalCertificate(processid: processid) { (filename, err) in
            completion(filename, err)
            return
        }
    }
}

//MARK: - Download seperate document
extension GetDocumentTrail {
    func downloadseperateDocument(processid: String, multidocid: Int, docname: String, completion: @escaping(String?, Bool) ->()) {
        
        AuditTrailAPI.sharedInstance.downloadseperateDocument(processid: processid, multidocid: multidocid, docname: docname) { (filename, err) in
            completion(filename, err)
            return
        }
    }
}

