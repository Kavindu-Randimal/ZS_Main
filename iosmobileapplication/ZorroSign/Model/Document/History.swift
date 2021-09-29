//
//  History.swift
//  ZorroSign
//
//  Created by Apple on 10/08/18.
//  Copyright © 2018 Apple. All rights reserved.
//

import UIKit

class History: WSBaseData {

    var ChangeSets: [ChangeSetsData] = []
    var Attachments: [AttachmentsData] = []
    
    override func populate(fromDictionary dict: NSDictionary) {
        super.populate(fromDictionary: dict)
    
        if let arr = dict.object(forKey: "ChangeSets") as? NSArray {

            for dic in arr {
                self.ChangeSets.append(ChangeSetsData(dictionary:dic as! [AnyHashable : Any]))
            }
        }
        if let arr = dict.object(forKey: "Attachments") as? NSArray {
            
            for dic in arr {
                self.Attachments.append(AttachmentsData(dictionary:dic as! [AnyHashable : Any]))
            }
        }
    }
}
