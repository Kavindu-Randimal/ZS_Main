//
//  Validator.swift
//  ZorroSign
//
//  Created by Mathivathanan on 10/7/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import Foundation

enum ValidateError: Error {
    case invalidData(String)
}

protocol ValidatorDelegate {
    func isValidEmailAddress(email: String) -> Bool
    func isValidPhoneNumber(phone: String?) -> Bool
    func isValidPassword(password: String) -> Bool
}

extension ValidatorDelegate {
    
    // MARK: - Validate Email
    
    func isValidEmailAddress(email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailTest = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
        if emailTest.evaluate(with: email) {
            return true
        }
        return false
    }
    
    // MARK: - Validate PhoneNumber
    
    func isValidPhoneNumber(phone: String?) -> Bool {
        let charcterSet  = NSCharacterSet(charactersIn: "+0123456789").inverted
        let inputString = phone?.components(separatedBy: charcterSet)
        let filtered = inputString?.joined(separator: "")
        return (phone == filtered) && ((filtered!.count) == 12)
    }
    
    // MARK: - Validate Password
    
    func isValidPassword(password: String) -> Bool {
        let passwordRegex = "^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)(?=.*[d$@$_!%*?&#])[A-Za-z\\dd$@$_!%*?&#]{8,}"
        let passwordTest = NSPredicate(format: "SELF MATCHES %@", passwordRegex)
        if passwordTest.evaluate(with: password) {
            return true
        }
        return false
    }
}

