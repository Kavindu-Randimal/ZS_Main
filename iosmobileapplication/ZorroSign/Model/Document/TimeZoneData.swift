//
//  TimeZoneData.swift
//  ZorroSign
//
//  Created by Apple on 13/08/18.
//  Copyright © 2018 Apple. All rights reserved.
//

import UIKit

class TimeZoneData: WSBaseData {

    /*
     {
     "Id": "UTC-09",
     "DisplayName": "(UTC-09:00) Coordinated Universal Time-09",
     "StandardName": "UTC-09",
     "DaylightName": "UTC-09",
     "BaseUtcOffset": "-09:00:00",
     "MomentZoneName":"Pacific/Gambier",
     "AdjustmentRules": null,
     "SupportsDaylightSavingTime": false
     }
     */
    
    var Id: String?
    var DisplayName: String?
    var StandardName: String?
    var DaylightName: String?
    var BaseUtcOffset: String?
    var MomentZoneName: String?
    var AdjustmentRules: NSDictionary?
    var SupportsDaylightSavingTime: Bool?
    
    override func populate(fromDictionary dict: NSDictionary) {
        super.populate(fromDictionary: dict)
        
        if let id = dict.object(forKey: "Id") as? String {
            self.Id = id
        }
        if let displayName = dict.object(forKey: "DisplayName") as? String {
            self.DisplayName = displayName
        }
        if let standardName = dict.object(forKey: "StandardName") as? String {
            self.StandardName = standardName
        }
        if let daylightName = dict.object(forKey: "DaylightName") as? String {
            self.DaylightName = daylightName
        }
        if let baseUtcOffset = dict.object(forKey: "BaseUtcOffset") as? String {
            self.BaseUtcOffset = baseUtcOffset
        }
        if let momentZoneName = dict.object(forKey: "MomentZoneName") as? String {
            self.MomentZoneName = momentZoneName
        }
        if let adjustmentRules = dict.object(forKey: "AdjustmentRules") as? NSDictionary {
            self.AdjustmentRules = adjustmentRules
        }
        if let supportsDaylightSavingTime = dict.object(forKey: "SupportsDaylightSavingTime") as? Bool {
            self.SupportsDaylightSavingTime = supportsDaylightSavingTime
        }
    }
}
