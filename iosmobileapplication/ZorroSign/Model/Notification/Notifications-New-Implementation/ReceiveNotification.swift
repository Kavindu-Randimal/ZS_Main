//
//  ReceiveNotification.swift
//  ZorroSign
//
//  Created by Anuradh Caldera on 7/23/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import Foundation

struct ReceiveNotification: Codable {
    var StatusCode: Int?
    var Message: String?
    var `Data`: [NotificationDetails]?
}

struct NotificationDetails: Codable {
    var Id: Int?
    var Email: String?
    var ProfileId: String?
    var DeviceId: String?
    var ProcessId: Int?
    var WorkflowId: Int?
    var MessageBody: String?
    var MessageTitle: String?
    var MessageLabel: String?
    var SentDate: String?
    var IsDeleted: Bool?
    var IsRead: Bool?
    var NotificationType: Int?
    var notifDate: Date?
}

extension ReceiveNotification {
    func getPushNotificationDetails(deviceid: String, completion: @escaping([NotificationDetails]?) -> ()) {
        ZorroHttpClient.sharedInstance.getpushnotificationDetails(deviceide: deviceid) { (notificatoins) in
            completion(notificatoins)
            return
        }
    }
}
