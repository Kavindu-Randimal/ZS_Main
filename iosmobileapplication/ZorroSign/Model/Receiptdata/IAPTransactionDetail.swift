//
//  IAPTransactionDetail.swift
//  ZorroSign
//
//  Created by Mathivathanan on 2021-04-19.
//  Copyright © 2021 Apple. All rights reserved.
//

import Foundation

struct IAPTransactionDetail: Codable {
    
    var organizationName: String?
    var originalTransactionId: String?
    var transactionId: String?
    var userEmail: String?
    var newProductId: String?
    
    var receiptData: String?
    var password: String?
    var isSandbox: Bool?
}

extension IAPTransactionDetail {
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

extension IAPTransactionDetail {
    func postIAPTransactionData(transactionData: IAPTransactionDetail, completion: @escaping (Bool, Int, String?) -> ()) {
        
        ZorroHttpClient.sharedInstance.postIAPPurchaseDetails(transactionData: transactionData) { (success, statusCode, message) in
            
            if !success {
                completion(false, statusCode, message)
                return
            }
            
            completion(true, statusCode, message)
            return
        }
    }
}
