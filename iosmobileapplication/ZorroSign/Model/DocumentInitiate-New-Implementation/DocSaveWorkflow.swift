//
//  DocSaveWorkflow.swift
//  ZorroSign
//
//  Created by Anuradh Caldera on 8/26/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import Foundation

struct DocSaveWorkflow: Codable {
    var Id: String!
    var Name: String!
    var Description: String!
    var Documents: [Documents]?
    var Steps: [Steps]?
    var IsDraft: Bool?
    var IsSingleInstance: Bool?
    var NoteDetails: [NoteDetails]?
    var DynamicTextDetails: [DynamicTextDetails]?
    var KBAStatus: Int = -1
    var OTPCode: Int?
    var Password: String?
    var CanSendEmail: Bool?
    var InstanceValidPeriod: Int?
    
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

extension DocSaveWorkflow {
    func saveWorkFlowDetails(docsaveworkflow: DocSaveWorkflow, completion: @escaping(Bool, String?) ->()) {
        ZorroHttpClient.sharedInstance.saveinitiatedWorkFlow(docsaveworkflow: docsaveworkflow) { (success, message) in
            completion(success, message)
            return
        }
    }
}

struct Documents: Codable {
    var ObjectId: String?
    var DocType: Int?
    var Name: String?
    var OriginalName: String?
}

struct Steps: Codable {
    var StepNo: String?
    var CCList: [CCList] = []
    var CCSignatories: [Signatory]?
    var Tags: [Tags] = []
}

struct CCList: Codable {
    var Id: String?
    var `Type`: Int?
    var UserName: String?
    var IsCC: Bool?
}

struct Tags: Codable {
    var `Type`: Int?
    var Signatories: [Signatory]?
    var dueDate: String?
    var TimeGap : Int?
    var TagPlaceHolder: Holder?
    var ExtraMetaData: SaveExtraMetaData?
    var TagNo: Int?
}

struct SaveExtraMetaData: Codable {
    var SignatureId: Int?
    var CheckState: String?
    var DateFormat: String?
    var IsDateAuto: Bool?
    var IsTimeOnly: Bool?
    var IsWithTime: Bool?
    var TagText: String?
    var TimeFormat: String?
    var TimeStamp: Int?
    var AttachmentCount: Int?
    var AttachmentDiscription: String?
    var AddedBy: String?
    var FontColor: String?
    var FontId: Int?
    var FontSize: Int?
    var FontStyle: String?
    var FontType: String?
    var lock: Bool?
}

struct NoteDetails: Codable {
    var StepNo: Int?
    var TagValue: TagValues?
    var TagText: String?
    var ObjectId: String?
    var Comment: String?
    var IsDynamicTag: Bool?
    var Signatory: String?
}

struct TagValues: Codable {
    var `Type`: Int?
    var Signatories: [Signatory]?
    var TagPlaceHolder: Holder?
    var ExtraMetaData: SaveExtraMetaData?
    var TagNo: Int?
    var State: Int?
    
}

struct DynamicTextDetails: Codable {
    var TagValue: TagValues?
    var TagText: String?
    var ObjectId: String?
    var Comment: String?
    var IsDynamicTag: Bool?
    var Signatory: String?
}



