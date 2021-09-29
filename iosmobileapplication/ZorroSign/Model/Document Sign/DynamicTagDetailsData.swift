//
//  DynamicTagDetailsData.swift
//  ZorroSign
//
//  Created by Apple on 09/09/18.
//  Copyright © 2018 Apple. All rights reserved.
//

import UIKit

@available(iOS 11.0, *)
class DynamicTagDetailsData: WSBaseData {

    /*
     {
     Comment = "<null>";
     IsDeleted = 0;
     IsDynamicTag = 0;
     IsLocked = 0;
     SignedAt = "2018-09-08T16:09:05";
     StepNo = 0;
     TagText = "";
     TagValue =             {
     DueDate = "<null>";
     ExtraMetaData =                 {
     AddedBy = "Ruwan lastname";
     lock = False;
     };
     ObjectId = "<null>";
     Signatories =                 (
     );
     State = 1;
     TagId = 563;
     TagNo = 1;
     TagPlaceHolder =                 {
     Height = "166.67";
     PageNumber = 1;
     Width = "133.33";
     XCoordinate = "-23.33";
     YCoordinate = "186.67";
     };
     Type = 8;
     };
     }
     */
    var Comment: String?
    var IsDeleted: Int?
    var IsDynamicTag: Int?
    var IsLocked: Int?
    var SignedAt: String?
    var StepNo: Int?
    var TagText: String?
    var TagValue: TagsData?
    var TextRevisionHistory: [String]?
    var Signatory: String?
    var txtvw: UITextView!
    
    override func populate(fromDictionary dict: NSDictionary) {
        super.populate(fromDictionary: dict)
        
        if let Comment = dict.object(forKey: "Comment") as? String {
            self.Comment = Comment
        }
        if let IsDeleted = dict.object(forKey: "IsDeleted") as? Int {
            self.IsDeleted = IsDeleted
        }
        if let IsDynamicTag = dict.object(forKey: "IsDynamicTag") as? Int {
            self.IsDynamicTag = IsDynamicTag
        }
        if let IsLocked = dict.object(forKey: "IsLocked") as? Int {
            self.IsLocked = IsLocked
        }
        if let SignedAt = dict.object(forKey: "SignedAt") as? String {
            self.SignedAt = SignedAt
        }
        if let StepNo = dict.object(forKey: "StepNo") as? Int {
            self.StepNo = StepNo
        }
        if let TagText = dict.object(forKey: "TagText") as? String {
            self.TagText = TagText
        }
        if let dic = dict.object(forKey: "TagValue") as? [String:Any] {
            if #available(iOS 11.0, *) {
                self.TagValue = TagsData(dictionary: dic)
            } else {
                // Fallback on earlier versions
            }
        }
    }
    
    func toDictionary()-> [String: Any] {
        var dic: [String:Any] = [:]
        
        dic["Comment"] = self.Comment
        dic["IsDeleted"] = self.IsDeleted
        dic["IsDynamicTag"] = self.IsDynamicTag
        dic["IsLocked"] = self.IsLocked
        dic["SignedAt"] = self.SignedAt
        dic["StepNo"] = self.StepNo
        dic["TagText"] = self.TagText
        dic["TagValue"] = self.TagValue?.toDictionary()
        dic["Signatory"] = self.Signatory
        
        return dic
    }
}
