//
//  OTPOnBoard.swift
//  ZorroSign
//
//  Created by Anuradh Caldera on 10/12/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import Foundation

struct OTPOnBoard: Codable {
    private var MobileNumber: String?
    
    init(mobileNumber: String) {
        self.MobileNumber = mobileNumber
    }
    
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

//MARK: - OnBoard Process
extension OTPOnBoard {
    func onboardusertoOTP(otponboard: OTPOnBoard, completion: @escaping(Bool) -> ()) {
        
        ZorroHttpClient.sharedInstance.onboarduserforOntimePassword(otponboard: otponboard) { (onboarded) in
            completion(onboarded)
            return
        }
    }
}
