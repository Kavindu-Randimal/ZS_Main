//
//  SubscriptionBanners.swift
//  ZorroSign
//
//  Created by Chathura Ellawala on 5/20/21.
//  Copyright © 2021 Apple. All rights reserved.
//

enum SubscriptionPlan: Int {
    case individual = 1
    case professional = 2
    case business = 3
    case enterprise = 4
    case zohoBasic = 5
    case zohoIndividual = 6
    case zohoBusiness = 7
    case zohoEnterprise = 8
}

enum SubscriptionType: Int {
    case individual = 3
    case professional_1_year = 4
    case professiona_2_year = 5
    case business_1_year = 6
    case business_2_year = 7
    case docpacks_100 = 8
    case docpacks_250 = 9
    case dockpacks_500 = 10
    case enterprise_1_year = 11
    case enterprise_2_year = 12
    case zs_basic = 13
    case ind_std_trail = 14
    case ind_std_monthly = 15
    case ind_std_yearly = 16
    case ind_unlim_monthly = 17
    case ind_unlim_yearly = 18
    case bis_std_trail = 19
    case bis_std_monthly = 20
    case bis_std_yearly = 21
    case bis_unlim_monthly = 22
    case bis_unlim_yearly = 23
    case bis_signer_monthly = 24
    case bis_signer_yearly = 25
    case docs_packs_5 = 26
    case docs_packs_10 = 27
    case enter_small_yearly = 28
    case enter_medium_yearly = 29
    case enter_large_yearly = 30
    case ao_ent_doc_t1 = 31
    case ao_ent_doc_t2 = 32
    case ao_ent_doc_t3 = 33
    case ao_ent_doc_t4 = 34
    case ao_ent_doc_t5 = 35
    case ao_ent_doc_t6 = 36
    case enter_user = 37
}

struct SubscriptionBanners {
    
    public static var shared = SubscriptionBanners()
    
    //MARK: - Check Admin/non Admin user in organization
    func checkIsAdmin(roles: [UserLoginDataRoles]) -> Bool {
        var isadmin = false
        for role in roles {
            if let _isdefault = role.IsDefault, let _name = role.Name {
                if _isdefault && _name == "Admin" {
                    isadmin = true
                } else {
                    isadmin = false
                }
            }
        }
        return isadmin
    }
    
    //MARK - Change the expirey date format
    func convertDate(date: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        guard let _formatted = formatter.date(from: date) else { return "" }
        
        formatter.dateFormat = "yyyy"
        let year = formatter.string(from: _formatted)
        formatter.dateFormat = "MM"
        let month = formatter.string(from: _formatted)
        formatter.dateFormat = "dd"
        let day = formatter.string(from: _formatted)
        return "\(year)/\(month)/\(day)"
    }
    
    //MARK: - Set title for subscription banner
    func getTitleForSubscriptionBanner(completion: @escaping(String, Bool) -> ()) {
        
        if let subscriptionData = UserDefaults.standard.object(forKey: "subscriptionData") as? Data {
            let decoder = JSONDecoder()
            if let decodedSubscription = try? decoder.decode(Subscription.self, from: subscriptionData) {
                print(decodedSubscription)
                guard let totaldocumentCount = decodedSubscription.TotalDocumentSetCount, let documentSets = decodedSubscription.AvailableDocumentSetCount, let expireyDate = decodedSubscription.ExpireDateTime, let subscriptionType = decodedSubscription.SubscriptionType, let subscriptionPlan = decodedSubscription.SubscriptionPlan else {
                    completion("", false)
                    return
                }
                
                let formatter = DateFormatter()
                let calendar = Calendar.current
                formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
                
                let today = NSDate()
                let currentDate = formatter.string(from: today as Date)
                
                guard let startDate = formatter.date(from: currentDate), let endDate = formatter.date(from: expireyDate) else {
                    completion("", false)
                    return
                }
                
                guard let _diff = calendar.dateComponents([.day], from: startDate, to: endDate).day else {
                    completion("", false)
                    return
                }
                
                let diff = Int(_diff)
                
                //Check current date is less than or equal to 7 days
                if diff <= 7 && diff > 0 {
                    let _formattedexpireyDate = convertDate(date: expireyDate)
                    if subscriptionType == SubscriptionType.ind_std_monthly.rawValue || subscriptionType == SubscriptionType.ind_std_yearly.rawValue || subscriptionType == SubscriptionType.ind_unlim_monthly.rawValue || subscriptionType == SubscriptionType.ind_unlim_yearly.rawValue || subscriptionType == SubscriptionType.enter_small_yearly.rawValue || subscriptionType == SubscriptionType.enter_medium_yearly.rawValue || subscriptionType == SubscriptionType.enter_large_yearly.rawValue {
                        completion("Your ZorroSign subscription will automatically renew on \(_formattedexpireyDate).", false)
                        return
                    }
                    
                    //Check business admin/ Not admin but subscribed users(has license)
                    let userType = ZorroTempData.sharedInstance.getUserType()
                    if userType == 1 {
                        if let _hassubscriptionData = UserDefaults.standard.object(forKey: "hasSubscriptionData") as? Bool {
                            if (_hassubscriptionData) {
                                //Have a valid license
                                if subscriptionPlan == SubscriptionPlan.zohoBusiness.rawValue && subscriptionType != SubscriptionType.bis_std_trail.rawValue {
                                    completion("Your ZorroSign subscription will automatically renew on \(_formattedexpireyDate).", false)
                                    return
                                }
                            }
                        }
                    }
                } else if diff <= 0 {
                    if subscriptionType == SubscriptionType.ind_std_trail.rawValue || subscriptionType == SubscriptionType.bis_std_trail.rawValue {
                        completion("Your trial subscription has expired.  Upgrade your ZorroSign subcription here to Z-Sign more documents.", true)
                        return
                    }
                }
                
                //Check business user without valid license
                let userType = ZorroTempData.sharedInstance.getUserType()
                if userType == 1 {
                    if let _hassubscriptionData = UserDefaults.standard.object(forKey: "hasSubscriptionData") as? Bool {
                        if (!_hassubscriptionData) {
                            //Not having a valid license
                            if subscriptionPlan == SubscriptionPlan.zohoBusiness.rawValue && subscriptionType != SubscriptionType.bis_std_trail.rawValue {
                                completion("Please contact your system admin to assign a valid ZorroSign subscription to your account.", false)
                                return
                            }
                        }
                    }
                }
                
                //Check user has unlimited documents or limited documents
                if totaldocumentCount > 0 {
                    //                    let docPercentage = (documentSets / totaldocumentCount) * 100
                    //                    if 0 < docPercentage && 15 > docPercentage {
                    if subscriptionType == SubscriptionType.ind_std_trail.rawValue || subscriptionType == SubscriptionType.bis_std_trail.rawValue {
                        if documentSets <= 3 {
                            completion("You have \(documentSets) document(s) remaining on your trial subscription.  Upgrade your ZorroSign subcription here to Z-Sign more documents.", true)
                            return
                        }
                    } else if subscriptionType == SubscriptionType.ind_std_monthly.rawValue || subscriptionType == SubscriptionType.bis_std_monthly.rawValue {
                        if documentSets <= 3 {
                            completion("You have \(documentSets) document(s) remaining to Z-Sign this month.  Select here to upgrade your plan or add additional documents and Z-Sign more.", true)
                            return
                        }
                    } else if subscriptionType == SubscriptionType.ind_std_yearly.rawValue || subscriptionType == SubscriptionType.bis_std_yearly.rawValue {
                        if documentSets <= 10 {
                            completion("You have \(documentSets) document(s) remaining to Z-Sign this year.  Select here to upgrade your plan or add additional documents and Z-Sign more.", true)
                            return
                        }
                    } else if subscriptionType == SubscriptionType.enter_small_yearly.rawValue || subscriptionType == SubscriptionType.enter_medium_yearly.rawValue  || subscriptionType == SubscriptionType.enter_large_yearly.rawValue {
                        if documentSets <= 10 {
                            completion("You have \(documentSets) document(s) remaining to Z-Sign this year.  Contact your ZorroSign Account Manager to upgrade your plan or add additional documents and Z-Sign more.", false)
                            return
                        }
                    }
                    //                    }
                }
            }
            completion("", false)
            return
        }
        completion("", false)
        return
    }
}
