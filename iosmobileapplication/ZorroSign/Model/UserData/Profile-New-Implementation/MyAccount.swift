//
//  MyAccount.swift
//  ZorroSign
//
//  Created by Anuradh Caldera on 6/12/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import Foundation

struct MyAccount: Codable {
    
    var StatusCode: Int?
    var Message: String?
    var `Data`: MyAccountData?
}

// MARK: get user data
extension MyAccount {
    func getmyaccountDocumentSummary(completion: @escaping(MyAccount?) -> ()) {
        ZorroHttpClient.sharedInstance.getDocumentSummary { (myaccount) in
            completion(myaccount)
        }
    }
}

struct MyAccountData: Codable {
    
    var StartedCount: Int?
    var ArchivedCount: Int?
    var InboxCount: Int?
    var InProcessCount: Int?
    var CompvaredCount: Int?
    var RejectedCount: Int?
    var CancelledCount: Int?
    var ExpiredCount: Int?
    var RecalledCount: Int?
    var SharedByMeCount: Int?
    var SharedToMeCount: Int?
    var TokenScannedCount: Int?
    var PermissionAcceptedCount: Int?
    var UsedDocSetCount: Int?
    var TotalDocSetCount: Int?
    var AvailableDocSetCount: Int?
    var TotalLicenseCount: Int?
    var UsedLicenseCount: Int?
    var AvailableLicenseCount: Int?
    var ExpiredLicenseCount: Int?
    var InactiveUserCount: Int?
    var LicenseExpiryDateTime: String?
}
