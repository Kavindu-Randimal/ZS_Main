//
//  ReceiptData.swift
//  ZorroSign
//
//  Created by Mathivathanan on 2021-04-19.
//  Copyright © 2021 Apple. All rights reserved.
//

import Foundation

struct ReceiptData: Codable {
    var receipt: Receipt?
    var environment: String?
    var latest_receipt_info: [LatestReceiptInfo]?
    var latest_receipt: String?
    var status: Int?
}

struct Receipt: Codable {
    var receipt_type: String?
    var bundle_id: String?
    var in_app: [LatestReceiptInfo]?
}

struct LatestReceiptInfo: Codable {
    var product_id: String?
    var transaction_id: String?
    var original_transaction_id: String?
    var is_trial_period: String?
}
