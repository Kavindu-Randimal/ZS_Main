//
//  TimeZoneAPI.swift
//  ZorroSign
//
//  Created by Mathivathanan on 8/18/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import Foundation

class TimeZoneAPI {
    
    static let shared = TimeZoneAPI()
    
    private init() {}
}

extension TimeZoneAPI {
    
    func getUTCTimeZoneData(completion: @escaping([ZorroTimeZone]?) -> ()) {
        
        guard let url = ZorroTempStrings.UTC_TIMEZONE_FILE_URL else {
            print("unable to read")
            completion([])
            return
        }
        
        do {
            let data = try Data(contentsOf: url)
            let timezones = try JSONDecoder().decode([ZorroTimeZone].self, from: data)
            completion(timezones)
            return
        } catch let err {
            print(err.localizedDescription)
            completion([])
            return
        }

    }
}
