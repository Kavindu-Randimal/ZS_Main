//
//  SubscriptionData.swift
//  ZorroSign
//
//  Created by Apple on 13/10/18.
//  Copyright © 2018 Apple. All rights reserved.
//

import UIKit

class SubscriptionData: WSBaseData {

    /*
     {
     "OrganizationId": 463,
     "UserSubscriptionId": 2325,
     "ExpireDateTime": "2019-09-30T05:07:26",
     "SubscriptionType": 6,
     "UserLicenseCount": 35
     }
     
     Subscription type is the license type a particular user has. Currently we have four license types, Starter, Professional, Business and Enterprise.
     Starter = 3 - Free account with 5 documents, once 5 documents utilized user has to upgrade to Professional or Business license types.
     Professional_1_Year = 4 - single user license valid for 1 year.
     Professional_2_Year = 5 - Single user license valid for 2 years - Currently we don't offer this type.
     Business_1_Year = 6 - Multiple user license valid for 1 year- User can create organizations (Business profile) and can add users to into it. Ruwan+bis3 account has this type.
     Business_2_Year = 7 - Same as above except validity period is two years - Currently we don't offer this type. These two types also not currently in use
     Enterprise_1_Year = 11,
     Enterprise_2_Year = 12,
     
     */
    var OrganizationId: Int?
    var UserSubscriptionId: Int?
    var ExpireDateTime: String?
    var SubscriptionType: Int?
    var UserLicenseCount: Int?
    var plandetailStr: String?
    
//    let planDic = [
//        3: "Free account",
//        4: "1 Year",
//        5: "2 Year",
//        6: "1 Year",
//        7: "2 Year",
//        11: "1 Year",
//        12: "2 Year",
//        13: "Basic account",
//        15: "1 Month",
//        16: "1 Year",
//        17: "1 Month",
//        18: "1 Year",
//        20: "1 Month",
//        21: "1 Year",
//        22: "1 Month",
//        23: "1 Year",
//        24: "1 Month",
//        25: "1 Year",
//        28: "1 Year",
//        29: "1 Year",
//        30: "1 Year",
//        37: "1 Year",
//    ]
    
    let planDic = [
        4: "1 Year",
        5: "2 Year",
        6: "1 Year",
        7: "2 Year",
        19: "Business Trail",
        20: "Business Standard",
        21: "Business Standard",
        22: "Business Unlimited",
        23: "Business Unlimited",
        24: "Business Signer",
        25: "Business Signer",
        28: "Enterprise",
        29: "Enterprise",
        30: "Enterprise"
    ]
    
    override func populate(fromDictionary dict: NSDictionary) {
        super.populate(fromDictionary: dict)
        
        if let OrganizationId = dict.object(forKey: "OrganizationId") as? Int {
            self.OrganizationId = OrganizationId
        }
        if let UserSubscriptionId = dict.object(forKey: "UserSubscriptionId") as? Int {
            self.UserSubscriptionId = UserSubscriptionId
        }
        if let ExpireDateTime = dict.object(forKey: "ExpireDateTime") as? String {
            self.ExpireDateTime = ExpireDateTime
        }
        if let SubscriptionType = dict.object(forKey: "SubscriptionType") as? Int {
            self.SubscriptionType = SubscriptionType
            let date: String = self.ExpireDateTime?.formatDateWith(format: "MMM dd, yyyy") ?? ""
            let type: String = planDic[self.SubscriptionType!] ?? ""
            self.plandetailStr = "\(type) \(date)"
        }
        if let UserLicenseCount = dict.object(forKey: "UserLicenseCount") as? Int {
            self.UserLicenseCount = UserLicenseCount
        }
    }
}
