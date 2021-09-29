//
//  DocumentinitiateSelectFiles.swift
//  ZorroSign
//
//  Created by Anuradh Caldera on 7/29/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import Foundation

struct DocumentinitiateSelectFile {
    
    var filename: String?
    var fileurl: URL?
    var isdeleted: Bool?
}

extension DocumentinitiateSelectFile {
    func uploadcreateworkflowfilesQueue(workflowid: Int, pdfpassword: String, selectedDocuments: [DocumentinitiateSelectFile], completion: @escaping(Bool) -> ()) {
        
        var isuploadsuccess: Bool = true
        let uploaddocumentdispatchGroup = DispatchGroup()
        
        for (index, document) in selectedDocuments.enumerated() {
            uploaddocumentdispatchGroup.enter()
            
            let createworkflowupload = CreateWorkflowUpload(workflowId: workflowid, CustomDocumentName: document.filename, Device: "iPhone", Browser: "Safari", OrderNum: index+1, PdfPassword: pdfpassword, DocumentType: 0)
            
            ZorroHttpClient.sharedInstance.uploadfiletocreateWorkFlow(workflowid: "\(workflowid)", createworkflowupload: createworkflowupload, fileurl: document.fileurl!, completion: { (success) in
                
                if !success {
                    isuploadsuccess = false
                }
                uploaddocumentdispatchGroup.leave()
            })
        }
        
        uploaddocumentdispatchGroup.notify(queue: .global()) {
            completion(isuploadsuccess)
            return
        }
    }
}
