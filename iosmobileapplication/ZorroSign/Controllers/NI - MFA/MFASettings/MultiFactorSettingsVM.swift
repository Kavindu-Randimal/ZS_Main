//
//  MFAVM.swift
//  ZorroSign
//
//  Created by Mathivathanan on 12/6/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import UIKit

enum MFASettings {
    case Force, Normal
}

enum MFAuthType {
    case BioMetric, OTP, None
}

struct MobileNo {
    var countryName: String?
    var code: String?
    var dialCode: String?
}

class MultiFactorSettingsVM: NSObject {

    var mfaSettings: MFASettings = .Normal
    var mfaType: MFAuthType = .None
    
    var mobileNo: MobileNo = MobileNo()
}
