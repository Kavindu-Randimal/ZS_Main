//
//  StepsData.swift
//  ZorroSign
//
//  Created by Apple on 31/08/18.
//  Copyright © 2018 Apple. All rights reserved.
//

import UIKit

@available(iOS 11.0, *)
class StepsData: WSBaseData {

    /*
     Steps =     (
     {
     CCList =             (
     );
     StepNo = 2;
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
     }
     );
     */
    var CCList: [Signatories]?
    var StepNo: Int?
    var Tags:[TagsData]?
    var signNo: Int = 0
    var IsKBA: Bool?
    
    override func populate(fromDictionary dict: NSDictionary) {
        super.populate(fromDictionary: dict)
        
        if let signlist = dict.object(forKey: "CCList") as? [[String:Any]] {
            
            self.CCList = []
            
            for dic in signlist {
                let list = Signatories(dictionary: dic)
                self.CCList?.append(list)
            }
        }
        if let stepNo = dict.object(forKey: "StepNo") as? Int {
            self.StepNo = stepNo
        }
        if let tagslist = dict.object(forKey: "Tags") as? [[String:Any]] {
            
            self.Tags = []
            for dic in tagslist {
                let list = TagsData(dictionary: dic)
                self.Tags?.append(list)
            }
        }
        
        if let iskba = dict.object(forKey: "IsKBA") as? Bool {
            self.IsKBA = iskba
        }
    }
}
