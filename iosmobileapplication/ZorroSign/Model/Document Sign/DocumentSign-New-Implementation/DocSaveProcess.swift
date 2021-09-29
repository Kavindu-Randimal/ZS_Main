//
//  DocSaveProcess.swift
//  ZorroSign
//
//  Created by Anuradh Caldera on 5/7/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import Foundation

struct DocSaveProcess: Codable {
    var password: String?
    var otpcode: Int?
    var processSaveDetailsDto: [ProcessSaveDetailsDto] = []
    
    enum CodingKeys: String, CodingKey {
        case password = "Password"
        case otpcode = "OTPCode"
        case processSaveDetailsDto = "ProcessSaveDetailsDto"
    }
    
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

struct ProcessSaveDetailsDto: Codable {
    var IssingleInstance: Bool? = false
    var workflowDefinitionID, processID: Int?
    var tagDetails: [TagDetails] = []
    var userPlaceHolderDetails : [String] = []
    var dynamicTagDetails: [DynamicTagDetail] = []
    var dynamicTextDetails: [DynamicTextDetail] = []
    var tagDetailString: TagDetailString?
    var pdfPassword: String?
    var geoLocation: String?
    
    enum CodingKeys: String, CodingKey {
        case workflowDefinitionID = "WorkflowDefinitionId"
        case processID = "ProcessId"
        case tagDetails = "TagDetails"
        case userPlaceHolderDetails = "UserPlaceHolderDetails"
        case dynamicTagDetails = "DynamicTagDetails"
        case dynamicTextDetails = "DynamicTextDetails"
        case IssingleInstance = "IsSingleInstance"
        case tagDetailString = "TagDetailString"
        case pdfPassword = "PdfPassword"
        case geoLocation = "Geolocation"
    }
}

struct TagDetailString: Codable {
    var kbaResult: String?
    var tagData: [TagData]?
    
    enum CodingKeys: String, CodingKey {
        case kbaResult = "KBAResult"
        case tagData = "TagData"
    }
}

struct TagDetails: Codable {
    var tagValue: TagValue?
    var tagText, comment: String?
    
    enum CodingKeys: String, CodingKey {
        case tagValue = "TagValue"
        case tagText = "TagText"
        case comment = "Comment"
    }
}

struct TagValue: Codable {
    var type: Int?
    var signatories: [Signatory] = []
    var tagPlaceHolder: Holder?
    var extraMetaData: ExtraMetaDataSave?
    var tagNo, state: Int?
    var objectID: String?
    
    enum CodingKeys: String, CodingKey {
        case type = "Type"
        case signatories = "Signatories"
        case tagPlaceHolder = "TagPlaceHolder"
        case extraMetaData = "ExtraMetaData"
        case tagNo = "TagNo"
        case state = "State"
        case objectID = "ObjectId"
    }
}

struct ExtraMetaDataSave: Codable {
    var tickX, tickY, tickW, tickH, textX, textY, textW, textH: Double?
    var checkState: String?
    var signatureID: Int?
    var count: Int?
    
    enum CodingKeys: String, CodingKey {
        case tickX = "TickX"
        case tickY = "TickY"
        case tickW = "TickW"
        case tickH = "TickH"
        case textX = "TextX"
        case textY = "TextY"
        case textW = "TextW"
        case textH = "TextH"
        case checkState = "CheckState"
        case signatureID = "SignatureId"
        case count = "Count"
    }
}

//MARK: Save Process
extension DocSaveProcess {
    func  savedocumentProcess(docsaveprocess: DocSaveProcess, completion: @escaping(Bool, String?) -> ()) {
        
        ZorroHttpClient.sharedInstance.saveDocumentProcess(docsaveprocess: docsaveprocess) { (res, err) in
            
            if let err = err {
                print("error wihile saving process : \(err)")
                completion(false, "Unable to complete the process : \(err)")
                return
            }
            
            if res != nil {
                print(res!.Data![0].Message!)
                completion(true, res!.Data![0].Message!)
                return
            }
        }
        
    }
}
