//
//  Localizer.swift
//  ZorroSign
//
//  Created by Mathivathanan on 10/7/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import Foundation

extension String {
    
    // MARK: - Alert Titles
    
    static let Alert = NSLocalizedString("Alert", comment: "")
    static let Confirmation = NSLocalizedString("Confirmation", comment: "")
    static let Error = NSLocalizedString("Error", comment: "")
    static let Success = NSLocalizedString("Success", comment: "")
    static let Failed = NSLocalizedString("Failed", comment: "")
    static let Oops = NSLocalizedString("Oops", comment: "")
    static let Warning = NSLocalizedString("Warning", comment: "")
    static let SomethingWentWrong = NSLocalizedString("Something went wrong.", comment: "")
    
    // MARK: - Error Messages
    
    static let EmptyFirstName = NSLocalizedString("Please enter firstname.", comment: "")
    static let EmptyLastName = NSLocalizedString("Please enter lastname.", comment: "")
    static let EmptyEmail = NSLocalizedString("Please enter email.", comment: "")
    static let InvalidEmail = NSLocalizedString("Invalid email address.", comment: "")
    static let InvalidPhone = NSLocalizedString("Invalid phone number.", comment: "")
    static let UnknownError = NSLocalizedString("Unknown Error.", comment: "")
    
    static let NoInternetConnection = NSLocalizedString("Internet connection appears to be offline.", comment: "")
}
