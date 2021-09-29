//
//  GetUserSubscriptionFeatures.swift
//  ZorroSign
//
//  Created by Mathivathanan on 2021-05-19.
//  Copyright © 2021 Apple. All rights reserved.
//

import Foundation

struct GetUserSubscriptionFeatures: Codable {
    
    var StatusCode: Int?
    var Message: String?
    var `Data`: PlanFeatures?
}

struct PlanFeatures: Codable {
    var PalnFeatures: [String]?
}

extension GetUserSubscriptionFeatures {
    
    func getUserSubscriptionFeatures(completion: @escaping(Bool, PlanFeatures?) -> ()) {
        ZorroHttpClient.sharedInstance.getUserSubscriptionFeatures { (success, userSubscriptionFeatures) in
            completion(success, userSubscriptionFeatures?.Data)
            return
        }
    }
}
