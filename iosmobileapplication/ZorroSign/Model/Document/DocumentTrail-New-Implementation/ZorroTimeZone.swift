//
//  ZorroTimeZone.swift
//  ZorroSign
//
//  Created by Anuradh Caldera on 6/28/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import Foundation

struct ZorroTimeZone: Codable {
    
    var Id: String?
    var DisplayName: String?
    var StandardName: String?
    var DaylightName: String?
    var BaseUtcOffset: String?
//    var AdjustmentRules: null,
    var MomentZoneName: String?
    var SupportsDaylightSavingTime: Bool?
}

//MARK: - Get UTC time
extension ZorroTimeZone {
    func getZorroTimeZoneData(completion: @escaping([ZorroTimeZone]?) -> ()) {
        TimeZoneAPI.shared.getUTCTimeZoneData { (zorrotimezones) in
            completion(zorrotimezones)
            return
        }
    }
}

//MARK: - Get TimeZone Display Name
extension ZorroTimeZone {
    func getUserTimeZoneDisplayName(momentzonename: String, completion: @escaping(ZorroTimeZone?) -> ()) {
        TimeZoneAPI.shared.getUTCTimeZoneData { (zorrotimezones) in
            if zorrotimezones != nil {
                let filteredZone = zorrotimezones!.filter {
                    $0.MomentZoneName!.contains(momentzonename)
                }.first
                completion(filteredZone)
                return
            }
        }
    }
}

