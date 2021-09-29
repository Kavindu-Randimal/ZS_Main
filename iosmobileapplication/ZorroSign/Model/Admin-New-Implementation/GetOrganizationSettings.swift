//
//  GetOrganizationSettings.swift
//  ZorroSign
//
//  Created by Anuradh Caldera on 11/18/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import Foundation

struct GetOrganizationSettings: Codable {
    
    var StatusCode: Int?
    var Message: String?
    var `Data`: GetSettingsData?
}

struct GetSettingsData: Codable {
    var KBAStatus: Int?
    var IsOrganizationMFAForced: Bool?
    var SuperAdminStatus: Int?
    var SigningLinkStatus: Int?
    var WebFormStatus: Int?
}

extension GetOrganizationSettings {
    func getAdminSettings(completion: @escaping(GetOrganizationSettings?) -> ()) {
        ZorroHttpClient.sharedInstance.getOrganizationSettings { (_orgsettings) in
            completion(_orgsettings)
            return
        }
    }
}
