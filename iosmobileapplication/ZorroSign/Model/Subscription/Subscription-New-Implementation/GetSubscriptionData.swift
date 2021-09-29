//
//  File.swift
//  ZorroSign
//
//  Created by Anuradh Caldera on 11/26/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import Foundation

struct GetSubscriptionData: Codable {
    
    var StatusCode: Int?
    var Message: String?
    var `Data`: Subscription?
}

struct Subscription: Codable {
    var ProfileId: String?
    var SubscriptionType: Int?
    var SubscriptionPlan: Int?
    var IsSubscriptionActive: Bool?
    var ExpireDateTime: String?
    var AvailableDocumentSetCount: Int?
    var TotalDocumentSetCount: Int?
}

extension GetSubscriptionData {
    func getUserSubscriptionData(completion: @escaping(Bool, Subscription?) -> ()) {
        ZorroHttpClient.sharedInstance.getSubscriptionData { (subscriptiondata) in
            completion(subscriptiondata?.Data?.IsSubscriptionActive ?? false, subscriptiondata?.Data)
            return
        }
    }
}
