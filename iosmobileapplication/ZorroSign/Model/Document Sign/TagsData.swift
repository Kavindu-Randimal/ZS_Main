//
//  TagsData.swift
//  ZorroSign
//
//  Created by Apple on 08/09/18.
//  Copyright © 2018 Apple. All rights reserved.
//

import UIKit
import PDFKit

@available(iOS 11.0, *)
class TagsData: WSBaseData {

    /*
     Tags =             (
     {
     DueDate = "2018-08-13T23:59:59";
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
     TagId = 13057;
     TagNo = 1;
     TagPlaceHolder =                     {
     Height = "26.67";
     PageNumber = 1;
     Width = "133.33";
     XCoordinate = 118;
     YCoordinate = "106.67";
     };
     Type = 0;
     }
     );
     */
    /*
     
     userName
     16
     userEmail
     17
     userCompany
     18
     userTitle
     19
     userPhone
     20
     
     Completed
     0
     Pending
     1
     Rejected
     2
     InFuture
     3
     Done
     4
     BulkSent
     5
     */
    
    
    var DueDate: String?
    var ExtraMetaData: [String:Any]?
    var ObjectId: String = ""
    var SignatoriesData: [Signatories]?
    var State: Int = 0
    var TagId: Int = 0
    var TagNo: Int?
    var TagPlaceHolder: TokenPlaceholderData?
    var type: Int?
    var flagAdded: Bool?
    var view: UIView?
    var signed: Bool = false
    var signImg: UIImageView?
    var TagText: String = ""
    var pdfAnnotation: PDFAnnotation?
    
    var dynamicTagData: DynamicTagDetailsData?
    
    override func populate(fromDictionary dict: NSDictionary) {
        super.populate(fromDictionary: dict)
        
        if let DueDate = dict.object(forKey: "DueDate") as? String {
            self.DueDate = DueDate
        }
        if let ExtraMetaData = dict.object(forKey: "ExtraMetaData") as? [String:Any] {
            self.ExtraMetaData = ExtraMetaData
        }
        if let signlist = dict.object(forKey: "Signatories") as? [[String:Any]] {
            
            self.SignatoriesData = []
            
            for dic in signlist {
                let list = Signatories(dictionary: dic)
                self.SignatoriesData?.append(list)
            }
        }
        if let State = dict.object(forKey: "State") as? Int {
            self.State = State
        }
        if let TagId = dict.object(forKey: "TagId") as? Int {
            self.TagId = TagId
        }
        if let TagNo = dict.object(forKey: "TagNo") as? Int {
            self.TagNo = TagNo
        }
        if let dic = dict.object(forKey: "TagPlaceHolder") as? [String:Any] {
            self.TagPlaceHolder = TokenPlaceholderData(dictionary: dic)
        }
        
        if let type = dict.object(forKey: "Type") as? Int {
            self.type = type
        }
        if let TagText = dict.object(forKey: "TagText") as? String {
            self.TagText = TagText
        }
    }
    
    func toDictionary()-> [String: Any] {
        var dic: [String:Any] = [:]
        
        dic["Type"] = self.type
        dic["TagNo"] = self.TagNo
        dic["State"] = self.State
        dic["ObjectId"] = self.ObjectId
        
        var signDic: [[String:Any]] = []
        if self.SignatoriesData != nil {
            for sign in self.SignatoriesData! {
                signDic.append(sign.toDictionary())
            }
        }
        dic["Signatories"] = signDic
        
        dic["TagPlaceHolder"] = self.TagPlaceHolder?.toDictionary()
        dic ["ExtraMetaData"] = self.ExtraMetaData
        dic["TagText"] = self.TagText
        
        return dic
    }
}
