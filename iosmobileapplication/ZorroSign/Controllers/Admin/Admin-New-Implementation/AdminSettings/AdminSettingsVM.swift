//
//  AdminSettingsVM.swift
//  ZorroSign
//
//  Created by Mathivathanan on 12/4/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import UIKit

class AdminSettingsVM: NSObject {

    // MARK: - Variables
    
    var valueMFA: Bool = false
    var valueKBA: Int = 0
    
    var getOrganizationSettings = GetOrganizationSettings()
    var postOrgSettings = PostOrganizationSettings()
    
    // MARK: - NetReq Get Organization Settings
    
    func netReqGetOrganizationSettings(completion: @escaping (Bool, String) -> ()) {
        getOrganizationSettings.getAdminSettings { (orgSettings) in
            guard let _orgSettings = orgSettings else {
                completion(false, "Unable to get Settings")
                return
            }
            
            self.getOrganizationSettings = _orgSettings
            completion(true, "Success")
        }
    }
    
    // MARK: - NetReq Post Organization Settings
    
    func netReqPostOrganizationSettings(completion: @escaping (Bool, String) -> ()) {
        postOrgSettings.KBAStatus = valueKBA
        postOrgSettings.IsOrganizationMFAForced = valueMFA
        
        postOrgSettings.updateAdminSettings(postoraganizationsettings: postOrgSettings) { (success, msg) in
            guard let _msg = msg else {
                completion(success, "")
                return
            }
            completion(success, _msg)
        }
    }
}
