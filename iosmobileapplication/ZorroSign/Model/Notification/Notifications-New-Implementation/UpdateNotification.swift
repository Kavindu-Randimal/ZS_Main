//
//  UpdateNotification.swift
//  ZorroSign
//
//  Created by Anuradh Caldera on 7/23/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import Foundation

struct UpdateNotification: Codable {
    
    var MessageId: Int?
    var IsDeleted: Bool?
    var IsRead: Bool?
    
    func convertdocprocesstoDictonary(jsonstring: String) -> [Any]? {
        if let data = jsonstring.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [Any]
            } catch let jsonerr {
                print("\(jsonerr.localizedDescription)")
            }
        }
        return nil
    }
}

extension UpdateNotification {
    func updatePushnotificationStatus(updatenoti: [UpdateNotification], completion: @escaping(Bool) -> ()) {
        ZorroHttpClient.sharedInstance.updatepushnotificationStatus(updatepush: updatenoti) { (completed) in
            completion(completed)
            return
        }
    }
}
