//
//  CreateWorkflowUpload.swift
//  ZorroSign
//
//  Created by Anuradh Caldera on 7/30/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import Foundation
import MobileCoreServices

struct CreateWorkflowUpload: Codable {
    
    var workflowId: Int?
    var CustomDocumentName: String?
    var Device: String?
    var Browser: String?
    var OrderNum: Int?
    var PdfPassword: String?
    var DocumentType: Int = 0
    
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

extension CreateWorkflowUpload {
    func mimeTypeForPath(path: String) -> String {
        let url = NSURL(fileURLWithPath: path)
        let pathExtension = url.pathExtension
        
        if let uti = UTTypeCreatePreferredIdentifierForTag(kUTTagClassFilenameExtension, pathExtension! as NSString, nil)?.takeRetainedValue() {
            if let mimetype = UTTypeCopyPreferredTagWithClass(uti, kUTTagClassMIMEType)?.takeRetainedValue() {
                return mimetype as String
            }
        }
        return "application/octet-stream"
    }
}


