//
//  ChainofAttachment.swift
//  ZorroSign
//
//  Created by Anuradh Caldera on 6/27/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import Foundation

struct ChainofAttachment {
    
    var isExpand: Bool!
    var chainofattachmentSub: [ChainofAttachmentSub] = []
    
    init(isexpand: Bool, documenttrailDetails: DocumentTrailDetails?) {
        self.isExpand = isexpand
        
        if let attachments = documenttrailDetails?.Data?.Documents {
            for attachment in attachments {
                if attachment.DocType == 1 {
                    let chainofdocumentsub = ChainofAttachmentSub(username: attachment.AttachedUser, attachmentname: attachment.Name, attachmentprofileid: attachment.AttachedUserProfileId, attachmentobjectid: attachment.ObjectId, filetype: getfileType(filename: attachment.Name))
                    chainofattachmentSub.append(chainofdocumentsub)
                }
            }
        }
    }
}

extension ChainofAttachment {
    fileprivate func getfileType(filename: String?) -> String {
        guard let fileName = filename else {
            return ""
        }
        let splitedfile = fileName.components(separatedBy: ".")
        return splitedfile.last!
    }
}

struct ChainofAttachmentSub {
    var username: String?
    var attachmentname: String?
    var attachmentprofileid: String?
    var attachmentobjectid: String?
    var filetype: String?
}

