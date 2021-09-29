//
//  ProcessData.swift
//  ZorroSign
//
//  Created by Apple on 31/08/18.
//  Copyright © 2018 Apple. All rights reserved.
//

import UIKit

@available(iOS 11.0, *)
class ProcessData: WSBaseData {

    var CreatedDate: String?
    var CreatedUser: Int?
    var DefinitionId: Int?
    var DefinitionName: String?
    var DocumentSetName: String?
    var Documents: [DocumentListData]?
    var DynamicTagDetails:[DynamicTagDetailsData] = []
    var DynamicTextDetails:[DynamicTagDetailsData] = []
    var ExtendedProcessData: String?
    var HasAToken: Int?
    var IsInitiated: Int?
    var IsLastStep: Int?
    var MainDocumentType: Int?
    var ModifiedDate: String?
    var ModifiedUser: Int?
    var OrganizationId: Int?
    var PageSizes: [Int]?
    var ProcessId: Int?
    var ProcessState: Int?
    var ProcessingStep: Int?
    var ProcessingSubSteps: [Int]?
    var Steps: [StepsData]?
    var TokenPlaceholder: TokenPlaceholderData?
    var UserPlaceHolders:[TokenPlaceholderData]?
    var processType: String?
    var selected: Bool = false
    
    /*
     {
     CreatedDate = "2018-08-22T16:03:32";
     CreatedUser = 2031;
     DefinitionId = 5053;
     DefinitionName = "Test 6";
     DocumentSetName = "Test 6";
     Documents =     (
     {
     AttachedUser = "<null>";
     AttachedUserProfileId = 0;
     DocType = 0;
     IsDeletable = 0;
     Name = "AAA_TestPdf";
     ObjectId = "workspace://SpacesStore/2c3a5569-cf5a-4b63-8388-f0e2d597ad6d;1.0";
     OriginalName = "<null>";
     }
     );
     DynamicTagDetails =     (
     );
     DynamicTextDetails =     (
     );
     ExtendedProcessData = "<null>";
     HasAToken = 0;
     IsInitiated = 1;
     IsLastStep = 1;
     MainDocumentType = 0;
     ModifiedDate = "2018-08-22T16:03:37";
     ModifiedUser = 2031;
     OrganizationId = 0;
     PageSizes =     (
     );
     ProcessId = 3674;
     ProcessState = 1;
     ProcessingStep = 2;
     ProcessingSubSteps =     (
     1
     );
     Steps =     (
     {
     CCList =             (
     );
     StepNo = 2;
     Tags =             (
     {
     DueDate = "2018-08-23T23:59:59";
     ExtraMetaData =                     {
     };
     ObjectId = "<null>";
     Signatories =                     (
     {
     FriendlyName = "<null>";
     Id = "F%2BnxcRjh5o8J1DmN%2Bn8Qtg%3D%3D";
     ProfileImage = "<null>";
     Type = 1;
     UserName = "<null>";
     }
     );
     State = 1;
     TagId = 13105;
     TagNo = 1;
     TagPlaceHolder =                     {
     Height = "26.67";
     PageNumber = 1;
     Width = "133.33";
     XCoordinate = 286;
     YCoordinate = 66;
     };
     Type = 0;
     }
     );
     }
     );
     TokenPlaceholder =     {
     Height = 0;
     PageNumber = 0;
     Width = 0;
     XCoordinate = 0;
     YCoordinate = 0;
     };
     UserPlaceHolders =     (
     );
     }
     */
    
    override func populate(fromDictionary dict: NSDictionary) {
        super.populate(fromDictionary: dict)

        if let CreatedDate = dict.object(forKey: "CreatedDate") as? String {
            self.CreatedDate = CreatedDate
        }
        if let CreatedUser = dict.object(forKey: "CreatedUser") as? Int {
            self.CreatedUser = CreatedUser
        }
        if let DefinitionId = dict.object(forKey: "DefinitionId") as? Int {
            self.DefinitionId = DefinitionId
        }
        if let DefinitionName = dict.object(forKey: "DefinitionName") as? String {
            self.DefinitionName = DefinitionName
        }
        if let DocumentSetName = dict.object(forKey: "DocumentSetName") as? String {
            self.DocumentSetName = DocumentSetName
        }
        
        if let doclist = dict.object(forKey: "Documents") as? [[String:Any]] {
            
            self.Documents = []
            for dic in doclist {
                let list = DocumentListData(dictionary: dic)
                self.Documents?.append(list)
            }
        }
        if let DynamicTagDetails = dict.object(forKey: "DynamicTagDetails") as? [[String:Any]] {
            
            self.DynamicTagDetails = []
            for dic in DynamicTagDetails {
                let tagdetails = DynamicTagDetailsData(dictionary: dic)
                self.DynamicTagDetails.append(tagdetails)
            }
        }
        if let DynamicTextDetails = dict.object(forKey: "DynamicTextDetails") as? [[String:Any]] {
            
            self.DynamicTextDetails = []
            for dic in DynamicTextDetails {
                let tagdetails = DynamicTagDetailsData(dictionary: dic)
                self.DynamicTextDetails.append(tagdetails)
            }
        }
        
        if let ExtendedProcessData = dict.object(forKey: "ExtendedProcessData") as? String {
            self.ExtendedProcessData = ExtendedProcessData
        }
        if let HasAToken = dict.object(forKey: "HasAToken") as? Int {
            self.HasAToken = HasAToken
        }
        if let IsInitiated = dict.object(forKey: "IsInitiated") as? Int {
            self.IsInitiated = IsInitiated
        }
        if let IsLastStep = dict.object(forKey: "IsLastStep") as? Int {
            self.IsLastStep = IsLastStep
        }
        if let MainDocumentType = dict.object(forKey: "MainDocumentType") as? Int {
            self.MainDocumentType = MainDocumentType
        }
        if let ModifiedDate = dict.object(forKey: "ModifiedDate") as? String {
            self.ModifiedDate = ModifiedDate
        }
        if let ModifiedUser = dict.object(forKey: "ModifiedUser") as? Int {
            self.ModifiedUser = ModifiedUser
        }
        if let OrganizationId = dict.object(forKey: "OrganizationId") as? Int {
            self.OrganizationId = OrganizationId
        }
        if let PageSizes = dict.object(forKey: "PageSizes") as? [Int] {
            
            for str in PageSizes {
                self.PageSizes?.append(str)
            }
        }
        if let ProcessId = dict.object(forKey: "ProcessId") as? Int {
            self.ProcessId = ProcessId
        }
        if let ProcessState = dict.object(forKey: "ProcessState") as? Int {
            self.ProcessState = ProcessState
        }
        if let ProcessingStep = dict.object(forKey: "ProcessingStep") as? Int {
            self.ProcessingStep = ProcessingStep
        }
        if let ProcessingSubSteps = dict.object(forKey: "ProcessingSubSteps") as? [Int] {
            
            for steps in ProcessingSubSteps {
                self.ProcessingSubSteps?.append(steps)
            }
        }
        if let Steps = dict.object(forKey: "Steps") as? [[String:Any]] {
            
            self.Steps = []
            for dic in Steps {
                let list = StepsData(dictionary: dic)
                self.Steps?.append(list)
            }
        }
        if let TokenPlaceholder = dict.object(forKey: "TokenPlaceholder") as? [String:Any] {
            self.TokenPlaceholder = TokenPlaceholderData(dictionary: TokenPlaceholder)
        }
        if let UserPlaceHolders = dict.object(forKey: "UserPlaceHolders") as? [[String:Any]] {
            
            self.UserPlaceHolders = []
            for dic in UserPlaceHolders {
                let list = TokenPlaceholderData(dictionary: dic)
                self.UserPlaceHolders?.append(list)
            }
        }
        

    }
}
