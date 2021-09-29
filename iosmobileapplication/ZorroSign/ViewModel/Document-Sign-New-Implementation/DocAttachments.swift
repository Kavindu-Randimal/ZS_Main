//
//  DocAttachments.swift
//  ZorroSign
//
//  Created by Anuradh Caldera on 7/12/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import Foundation

struct DocAttachments: Codable {
    
    var Id: Int?
    var ObjectId: String?
    var DocType: Int?
    var Name: String?
    var IsDeletable: Bool?
    var CreatedBy: Int?
    var AttachedUserProfileId: Int?
    var PageCount: Int?
    var IsPermanent: Bool?
    var SubStepId: Int?
    var isUploaded: Bool?
    var fileUrl: URL?
    
}

//MARK: - Upload files in a queue
extension DocAttachments {
    func uploadFilesQueue(processid: String, mandatoryAttachments: [DocAttachments], optionalAttachments: [DocAttachments], completion: @escaping(Bool) -> ()) {
        
        let attachamentdispatchGroup = DispatchGroup()
        
        let unuploadedattachments = filternonUploaded(mandatory: mandatoryAttachments, optional: optionalAttachments)
        
        if unuploadedattachments.count > 0 {
        
            for attachment in unuploadedattachments {
                attachamentdispatchGroup.enter()
                
                var permanant: String = "0"
                if attachment.IsPermanent! {
                    permanant = "1"
                } else {
                    permanant = "0"
                }
                
                let docattachmentUpload = DocAttachmentsUpload(CustomDocumentName: attachment.Name, DocumentType: attachment.DocType, IsPermanent: permanant)
                
                ZorroHttpClient.sharedInstance.uploadFiles(processid: processid, docattachment: docattachmentUpload, fileurl: attachment.fileUrl!, completion: { (success) in
                    attachamentdispatchGroup.leave()
                })
            }
            
            attachamentdispatchGroup.notify(queue: .global()) {
                print("upload done")
                completion(true)
                return
            }
        }
    }
}

//MARK: Filter only non uploaded files
extension DocAttachments {
    fileprivate func filternonUploaded(mandatory: [DocAttachments], optional: [DocAttachments]) -> [DocAttachments] {
        
        let allAttchments: [DocAttachments] = mandatory + optional
        var unuploadedAttachments: [DocAttachments] = []
        
        for attachment in allAttchments {
            if !attachment.isUploaded! {
                unuploadedAttachments.append(attachment)
            }
        }
        return unuploadedAttachments
    }
}

extension DocAttachments {
    func deleteAttachment(processid: String, objectid: String, tagid: String, completion: @escaping(Bool) -> ()) {
        
        ZorroHttpClient.sharedInstance.deleteAttachment(processid: processid, objectid: objectid, tagid: tagid) { (success) in
            completion(success)
            return
        }
    }
}
