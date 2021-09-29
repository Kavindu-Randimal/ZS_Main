//
//  PostOrganizationSettings.swift
//  ZorroSign
//
//  Created by Anuradh Caldera on 11/18/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import Foundation

struct PostOrganizationSettings: Codable {
    
    var Font: SettingsFonts?
    var KBAStatus: Int?
    var IsOrganizationMFAForced: Bool?
    
    func convertdocprocesstoDictonary(jsonstring: String) -> [String: Any]? {
        if let data = jsonstring.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            } catch let jsonerr {
                print("\(jsonerr.localizedDescription)")
            }
        }
        return nil
    }
}

struct SettingsFonts: Codable {
    
    var DisplayName: String?
    var FontFamily: String?
    var FontId: Int?
    var FontSize: Int?
    var FontType: String?
    var HasBold: Bool?
    var HasBoldItalic: Bool?
    var HasItalic: Bool?
    var IsDefault: Bool?
    var MaxSize: Int?
    var MinSize: Int?
}


extension PostOrganizationSettings {
    func updateAdminSettings(postoraganizationsettings: PostOrganizationSettings, completion: @escaping(Bool, String?) ->()) {
        ZorroHttpClient.sharedInstance.saveOrganizationSettings(postorgSettings: postoraganizationsettings) { (_success, _errmessage) in
            completion(_success, _errmessage)
            return
        }
    }
}
