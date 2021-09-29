//
//  DashboardCategoryResponse.swift
//  ZorroSign
//
//  Created by Anuradh Caldera on 1/21/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import Foundation

struct DashbordCategoryRespone: Codable {
    var StatusCode: Int?
    var Message: String?
    var `Data`: [DashboardCategoryData]?
}

struct DashboardCategoryData: Codable {
    
    var InstanceId: Int?
    var ParentInstanceId: Int?
    var DocumentSet: String?
    var Template: String?
    var Originator: String?
    var OriginatorId: String?
    var OriginatorImage: String?
    var OriginatorEmail: String?
    var CurrentStep: Int?
    var TotalSteps: Int?
    var ElapsedDays: Int?
    var CurrentUser: String?
    var CurrentUserEmail: String?
    var CurrentUserImage: String?
    var CurrentUserList: [String]?
    var Flag: Bool?
    var StartDate: String?
    var EndDate: String?
    var WorkflowSourceCategory: Int?
    var Reason: String?
    var TemplateId: Int?
    var CanAccess: Bool?
    var MainDocumentType: Int?
    var DueDateTime: String?
    var ExpiryDateTime: String?
    var DueDays: Int?
    var SortOrder: Int?
    var IsExpired: Bool?
    var LabelList: [DashboardCategoryLabel]?
    var DashboardCategoryType: Int?
    var IsBulkSend: Bool?
    var IsBulkSendStepStarted: Bool?
    var CompletedBy: String?
    var CompletedByImage: String?
}

struct DashboardCategoryLabel: Codable {
    var LabelId: String?
    var ParentLabelId: String?
    var LabelName: String?
    var LabelPath: String?
    var LabelColor: String?
}
