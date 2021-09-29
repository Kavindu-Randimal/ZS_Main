//
//  ChainofDocument.swift
//  ZorroSign
//
//  Created by Anuradh Caldera on 6/27/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import Foundation

struct ChainofDocument {
    
    var isExpand: Bool!
    var chainofdocumentSub: [ChainofDocumentSub] = []
    
    init(isexpand: Bool, documenttrailDetails: DocumentTrailDetails?) {
        self.isExpand = isexpand
        
        let originatorname = documenttrailDetails?.Data?.Originator?.Name
        
        if let documents = documenttrailDetails?.Data?.MultiUploadDocumentInfo {
            for document in documents {
                let chainofdocumentsub = ChainofDocumentSub(username: originatorname, documentname: document.OriginalName, documentid: document.Id, documenturl: document.ObjectId)
                chainofdocumentSub.append(chainofdocumentsub)
            }
        }
    }
}

struct ChainofDocumentSub {
    var username: String?
    var documentname: String?
    var documentid: Int?
    var documenturl: String?
}
