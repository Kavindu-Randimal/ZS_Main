//
//  DashboardCategoryCountReponse.swift
//  ZorroSign
//
//  Created by Anuradh Caldera on 1/21/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import Foundation

struct DashbordCategoryCountRespone: Codable {
    var StatusCode: Int?
    var Message: String?
    var `Data`: DashboardCategoryCountData?
}

struct DashboardCategoryCountData: Codable {
    var TotalCounts: DashboardCategoryCountTotal?
    var SelectedCategory: Int?
    var Count: Int?
}

struct DashboardCategoryCountTotal: Codable {
    var Esign: Int? // 0
    var Pending: Int? // 1
    var Completed: Int? // 2
    var SharedToMe: Int? // 7
    var ScannedToken: Int? //8
    var Rejected: Int? // 3
    var Expired: Int? // 5
    var Canceled: Int? // 6
}
