//
//  DocProcess.swift
//  ZorroSign
//
//  Created by Anuradh Caldera on 4/28/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import Foundation

struct DocProcess: Codable {
    let statusCode: Int?
    let message: String?
    let data: DataClass?

    enum CodingKeys: String, CodingKey {
        case statusCode = "StatusCode"
        case message = "Message"
        case data = "Data"
    }
}

struct DataClass: Codable {
    let processID, parentProcessID, definitionID: Int?
    let documentSetName: String?
    let documents: [Document]?
    let organizationID: Int?
    let definitionName: String?
    let steps: [Step]?
    let processingStep: Int?
    let processingSubSteps: [Int]?
    let isInitiated: Bool?
    let createdUser: Int?
    let createdUsersName: String?
    let createdDate, modifiedUserString, modifiedDate: String?
    let processState, mainDocumentType: Int?
    let userPlaceHolders: [JSONNull]?
    let dynamicTagDetails: [DynamicTagDetail]?
    let dynamicTextDetails: [DynamicTextDetail]?
    let tokenPlaceholder: Holder?
    let isLastStep: Bool?
    var pageSizes: [PageSizes]?
    let hasAToken, isBulkSend, isSingleInstance: Bool?
    let multiUploadDocumentInfo: [Document]?
    let autoSavedData: AutoSavedData?
    let externalReferenceID: String?
    let kbaStatus: Int?

    enum CodingKeys: String, CodingKey {
        case processID = "ProcessId"
        case parentProcessID = "ParentProcessId"
        case definitionID = "DefinitionId"
        case documentSetName = "DocumentSetName"
        case documents = "Documents"
        case organizationID = "OrganizationId"
        case definitionName = "DefinitionName"
        case steps = "Steps"
        case processingStep = "ProcessingStep"
        case processingSubSteps = "ProcessingSubSteps"
        case isInitiated = "IsInitiated"
        case createdUser = "CreatedUser"
        case createdUsersName = "CreatedUsersName"
        case createdDate = "CreatedDate"
        case modifiedUserString = "ModifiedUserString"
        case modifiedDate = "ModifiedDate"
        case processState = "ProcessState"
        case mainDocumentType = "MainDocumentType"
        case userPlaceHolders = "UserPlaceHolders"
        case dynamicTagDetails = "DynamicTagDetails"
        case dynamicTextDetails = "DynamicTextDetails"
        case tokenPlaceholder = "TokenPlaceholder"
        case isLastStep = "IsLastStep"
        case pageSizes = "PageSizes"
        case hasAToken = "HasAToken"
        case isBulkSend = "IsBulkSend"
        case isSingleInstance = "IsSingleInstance"
        case multiUploadDocumentInfo = "MultiUploadDocumentInfo"
        case autoSavedData = "AutoSavedData"
        case externalReferenceID = "ExternalReferenceId"
        case kbaStatus = "KBAStatus"
    }
}

struct PageSizes: Codable {
    let PageNo: Int?
    let Height: Int?
    let Width: Int?
}

struct AutoSavedData: Codable {
    let processID: Int?
    let tagDetails: TagDetail?
    let dynamicTagDetails: [DynamicTagDetail]?
    let dynamicTextDetails: [DynamicTextDetail]?

    enum CodingKeys: String, CodingKey {
        case processID = "ProcessId"
        case tagDetails = "TagDetails"
        case dynamicTagDetails = "DynamicTagDetails"
        case dynamicTextDetails = "DynamicTextDetails"
    }
}

struct TagDetail: Codable {
    let kbaResult: String?
    let tagData: [TagData]?
    
    enum CodingKeys: String, CodingKey {
        case kbaResult = "KBAResult"
        case tagData = "TagData"
    }
}


struct TagData: Codable {
    let type: Int?
    let typeName: String?
    let id, tagNo, order, page: Int?
    let tagDetailClass: String?
    let x, y: Double?
    let adj: Adj
    let w, h: Double?
    let tagID: Int?
    let signatureID: Int?
    let selectedData: Bool?
    let tagDetailSignatureID: Int?
    let isClicked, apply: Bool?
    let timestamp: Int?
    let realTimeData: RealTimeData?
    let data, label: String?
    let checked, isDateAuto, isWithTime, isTimeOnly: Bool?
    let dateFormat, timeFormat: String?

    enum CodingKeys: String, CodingKey {
        case type, typeName, id, tagNo, order, page
        case tagDetailClass = "class"
        case x, y, adj, w, h
        case tagID = "tagId"
        case signatureID = "SignatureId"
        case selectedData
        case tagDetailSignatureID = "signatureId"
        case isClicked, apply, timestamp, realTimeData, data, label, checked, isDateAuto, isWithTime, isTimeOnly, dateFormat, timeFormat
    }
}

struct Adj: Codable {
    let x, y: Int?
}

struct RealTimeData: Codable {
    let id: Int?
    let tagDataID: String?
    let tagNo: Int?

    enum CodingKeys: String, CodingKey {
        case id = "Id"
        case tagDataID = "TagDataId"
        case tagNo = "TagNo"
    }
}

struct Document: Codable {
    let id: Int?
    let objectID: String?
    let docType: Int?
    let name: String?
    let originalName: String?
    let isDeletable: Bool?
    let attachedUser: String?
    let attachedUserProfileID, pageCount: Int?
    let orderNumber: Int?
    let isPermanent: Bool?

    enum CodingKeys: String, CodingKey {
        case id = "Id"
        case objectID = "ObjectId"
        case docType = "DocType"
        case name = "Name"
        case originalName = "OriginalName"
        case isDeletable = "IsDeletable"
        case attachedUser = "AttachedUser"
        case attachedUserProfileID = "AttachedUserProfileId"
        case pageCount = "PageCount"
        case orderNumber = "OrderNumber"
        case isPermanent = "IsPermanent"
    }
}

struct DynamicTagDetail: Codable {
    var stepNo: Int?
    var isDeleted, isLocked: Bool?
    var tagValue: DynamicTagDetailTagValue?
    var tagText: String?
    var comment: String?
    var isDynamicTag: Bool?
    var signedAt: String?

    enum CodingKeys: String, CodingKey {
        case stepNo = "StepNo"
        case isDeleted = "IsDeleted"
        case isLocked = "IsLocked"
        case tagValue = "TagValue"
        case tagText = "TagText"
        case comment = "Comment"
        case isDynamicTag = "IsDynamicTag"
        case signedAt = "SignedAt"
    }
}

struct DynamicTagDetailTagValue: Codable {
    var type: Int?
    var signatories: [Signatory]?
    var tagPlaceHolder: Holder?
    var extraMetaData: PurpleExtraMetaData?
    var tagNo, state: Int?
    var objectID: String?
    var tagID: Int?
    var dueDate: String?
    var timeGap: Int?

    enum CodingKeys: String, CodingKey {
        case type = "Type"
        case signatories = "Signatories"
        case tagPlaceHolder = "TagPlaceHolder"
        case extraMetaData = "ExtraMetaData"
        case tagNo = "TagNo"
        case state = "State"
        case objectID = "ObjectId"
        case tagID = "TagId"
        case dueDate = "DueDate"
        case timeGap = "TimeGap"
    }
}

struct PurpleExtraMetaData: Codable {
    var lock, addedBy, fontType, fontSize: String?

    enum CodingKeys: String, CodingKey {
        case lock
        case addedBy = "AddedBy"
        case fontType = "FontType"
        case fontSize = "FontSize"
    }
}

struct Step: Codable {
    let stepNo: Int?
    let ccList: [CcList]?
    let tags: [Tag]?
    let isBulkSend: Bool?

    enum CodingKeys: String, CodingKey {
        case stepNo = "StepNo"
        case ccList = "CCList"
        case tags = "Tags"
        case isBulkSend = "IsBulkSend"
    }
}

struct CcList: Codable {
    let isSingleSignatory, isCC: Bool?
    let id: String?
    let type: Int?
    let userName, groupName, groupImage, friendlyName: String?
    let profileImage: String?
    let profileID: String?
    let isLocked: Bool?
    
    enum CodingKeys: String, CodingKey {
        case isSingleSignatory = "IsSingleSignatory"
        case isCC = "IsCC"
        case id = "Id"
        case type = "Type"
        case userName = "UserName"
        case groupName = "GroupName"
        case groupImage = "GroupImage"
        case friendlyName = "FriendlyName"
        case profileImage = "ProfileImage"
        case profileID = "ProfileId"
        case isLocked = "IsLocked"
    }
}

struct Tag: Codable {
    let type: Int?
    let signatories: [Signatory]
    let tagPlaceHolder: Holder?
    let extraMetaData: ExtraMetaData?
    let tagNo, state: Int?
    let objectID: String?
    let tagID: Int?
    let dueDate: String?
    let timeGap: Int?
    let isTagPasswordProtected: Bool?

    enum CodingKeys: String, CodingKey {
        case type = "Type"
        case signatories = "Signatories"
        case tagPlaceHolder = "TagPlaceHolder"
        case extraMetaData = "ExtraMetaData"
        case tagNo = "TagNo"
        case state = "State"
        case objectID = "ObjectId"
        case tagID = "TagId"
        case dueDate = "DueDate"
        case timeGap = "TimeGap"
        case isTagPasswordProtected = "IsTagPasswordProtected"
    }
}

struct ExtraMetaData: Codable {
    let isDateAuto, isWithTime, isTimeOnly, dateFormat: String?
    let timeFormat, fontType, fontSize, fontStyle: String?
    let fontColor, fontID, mandatory, label: String?
    let attachmentDiscription: String?
    let attachmentCount: String?
    let signatureID: String?
    let checkState: String?
    let tagText: String?
    let Group: String?
    let CustomTextBoxEnable: String?
    
    enum CodingKeys: String, CodingKey {
        case isDateAuto = "IsDateAuto"
        case isWithTime = "IsWithTime"
        case isTimeOnly = "IsTimeOnly"
        case dateFormat = "DateFormat"
        case timeFormat = "TimeFormat"
        case fontType = "FontType"
        case fontSize = "FontSize"
        case fontStyle = "FontStyle"
        case fontColor = "FontColor"
        case fontID = "FontId"
        case mandatory = "Mandatory"
        case label = "Label"
        case attachmentDiscription = "AttachmentDiscription"
        case attachmentCount = "AttachmentCount"
        case signatureID = "SignatureId"
        case checkState = "CheckState"
        case tagText = "TagText"
        case Group = "Group"
        case CustomTextBoxEnable = "CustomTextBoxEnable"
    }
}

struct Signatory: Codable, Equatable {
    let id: String?
    let type: Int?
    let userName, groupName, groupImage, friendlyName: String?
    let profileImage: String?
    let profileID: String?
    let isLocked: Bool?

    enum CodingKeys: String, CodingKey {
        case id = "Id"
        case type = "Type"
        case userName = "UserName"
        case groupName = "GroupName"
        case groupImage = "GroupImage"
        case friendlyName = "FriendlyName"
        case profileImage = "ProfileImage"
        case profileID = "ProfileId"
        case isLocked = "IsLocked"
    }
}

struct Holder: Codable {
    var pageNumber: Int?
    var xCoordinate, yCoordinate, height, width: Double?

    enum CodingKeys: String, CodingKey {
        case pageNumber = "PageNumber"
        case xCoordinate = "XCoordinate"
        case yCoordinate = "YCoordinate"
        case height = "Height"
        case width = "Width"
    }
}

struct DynamicTextDetail: Codable {
    var textRevisionHistory: [String]?
    var isDeleted, isLocked: Bool?
    var tagValue: DynamicTextDetailTagValue?
    var tagText: String?
    var comment: String?
    var isDynamicTag: Bool?
    var signedAt: String?

    enum CodingKeys: String, CodingKey {
        case textRevisionHistory = "TextRevisionHistory"
        case isDeleted = "IsDeleted"
        case isLocked = "IsLocked"
        case tagValue = "TagValue"
        case tagText = "TagText"
        case comment = "Comment"
        case isDynamicTag = "IsDynamicTag"
        case signedAt = "SignedAt"
    }
}

struct DynamicTextDetailTagValue: Codable {
    var type: Int?
    var signatories: [Signatory]?
    var tagPlaceHolder: Holder?
    var extraMetaData: FluffyExtraMetaData?
    var tagNo, state: Int?
    var objectID: String?
    var tagID: Int?
    var dueDate: String?
    var timeGap: Int?

    enum CodingKeys: String, CodingKey {
        case type = "Type"
        case signatories = "Signatories"
        case tagPlaceHolder = "TagPlaceHolder"
        case extraMetaData = "ExtraMetaData"
        case tagNo = "TagNo"
        case state = "State"
        case objectID = "ObjectId"
        case tagID = "TagId"
        case dueDate = "DueDate"
        case timeGap = "TimeGap"
    }
}

struct FluffyExtraMetaData: Codable {
    var tagDataID, id, lock, addedBy: String?
    var fontType, fontSize, fontStyle, fontColor: String?
    var fontID: String?

    enum CodingKeys: String, CodingKey {
        case tagDataID = "TagDataId"
        case id = "Id"
        case lock
        case addedBy = "AddedBy"
        case fontType = "FontType"
        case fontSize = "FontSize"
        case fontStyle = "FontStyle"
        case fontColor = "FontColor"
        case fontID = "FontId"
    }
}

// MARK: Encode/decode helpers

class JSONNull: Codable, Hashable {
    
    public static func == (lhs: JSONNull, rhs: JSONNull) -> Bool {
        return true
    }
    
    public var hashValue: Int {
        return 0
    }
    
    func hash(into hasher: inout Hasher) { }
    
    public init() {}
    
    public required init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if !container.decodeNil() {
            throw DecodingError.typeMismatch(JSONNull.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for JSONNull"))
        }
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encodeNil()
    }
}
