//
//  DocumentTrailDetails.swift
//  ZorroSign
//
//  Created by Anuradh Caldera on 6/25/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import Foundation

struct DocumentTrailDetails: Codable {
    var StatusCode: Int?
    var Message: String?
    var `Data`: DocTrailData?
}

struct DocTrailData: Codable {
    var InstanceId: Int?
    var WorkflowId: Int?
    var DocumentSetName: String?
    var Documents: [DocTrailDocuments]?
    var MultiUploadDocumentInfo: [DocTrailMultiuplodadocInfo]?
    var Originator: DocTrailOriginator?
    var Steps: [DocTrailSteps]?
    var DocumentRenameHistory: [DocumentRenameHistory]?
    var ContractVersion: String?
    var DocumentSignature: String?
    var RestartedFromProcessId: Int?
}

struct DocTrailDocuments: Codable {
    var Id: Int?
    var ObjectId: String?
    var DocType: Int?
    var Name: String?
    var OriginalName: String?
    var IsDeletable: Bool?
    var CreatedBy: String?
    var AttachedUser: String?
    var AttachedUserProfileId: String?
    var PageCount: Int?
    var IsPermanent: Bool?
    var SubStepId: Int?
    var IsPasswordProtected: Bool?
}

struct DocTrailMultiuplodadocInfo: Codable {
    var OrderNumber: Int?
    var Id: Int?
    var ObjectId: String?
    var DocType: Int?
    var Name: String?
    var OriginalName: String?
    var IsDeletable: Bool?
    var CreatedBy: String?
    var AttachedUser: String?
    var AttachedUserProfileId: String?
    var PageCount: Int?
    var IsPermanent: Bool?
    var SubStepId: Int?
    var IsPasswordProtected: Bool?
}

struct DocTrailOriginator: Codable {
    var Name: String?
    var Email: String?
    var ProfileId: String?
    var Image: String?
}

struct DocTrailSteps: Codable {
    var InstanceStepId: Int?
    var TokenId: Int?
    var ExecutedUserName: String?
    var ExecutedUserEmail: String?
    var ExecutedProfileId: String?
    var ExecutedUserImage: String?
    var ReceivedTime: String?
    var FinishedTime: String?
    var History: DocTrailStepsHistory?
    var IsKBA: Bool?
    var TransactionId: String?
    var TransactionTimeStamp: String?
    var RawStepData: String?
    var StepStatus: String? 
    var IsGrayBySendback: Bool?
    var InstanceStepLabel: String?
    var KBAResult: String?
    
    // Newly added for New Audit Trail
    var Geolocation: String?
    var IPAddress: String?
    var ApprovalMethod: Int?
}

struct DocTrailStepsHistory: Codable {
    var ChangeSets: [DocTrailStepsHistoryChangeSets]?
    var Attachments: [DocumentTrailAttachments]?
}

struct DocTrailStepsHistoryChangeSets: Codable {
    var ExecutedBy: String?
    var ExecutedTime: String?
    var TagType: Int?
    var ExecutedUserName: String?
    var CertificateNumber: [DocTrailStepHistoryChangeSetsCertificateNumber]?
    var ExtendedMetaData: String?
    var DynamicTagtext: String?
    var SubStepId: Int?
    var ActionedTime: String?
    var IsDynamic: Bool?
    var KBAResult: String?
    var ExecutedByImage: String?
    var ExecutedByEmail: String?
}

struct DocTrailStepHistoryChangeSetsCertificateNumber: Codable {
    var SignatureId: Int?
    var SignatureTick: String?
    var SignatureDescription: String?
    var TokenId: Int?
    var ProfileId: String?
}

struct DocumentTrailAttachments: Codable {
    var AttachedFileName: String?
    var AttachedProfileId: String?
    var AttachedObjectId: String?
    var AttachedUserName: String?
}

struct DocumentRenameHistory: Codable {
    var DocumentSetName: String?
    var ModifiedDateTime: String?
    var ModifiedByProfileId: String?
    var RenamedAtStepNo: Int?
    var DocumentSetPreviousName: String?
}
