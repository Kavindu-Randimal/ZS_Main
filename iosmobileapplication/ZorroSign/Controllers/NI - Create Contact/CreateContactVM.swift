//
//  CreateContactVM.swift
//  ZorroSign
//
//  Created by Mathivathanan on 10/7/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class CreateContactVM: NSObject, ValidatorDelegate {
    
    // MARK: - Variables

    var firstName = BehaviorRelay<String>(value: "")
    var middelName = BehaviorRelay<String>(value: "")
    var lastName = BehaviorRelay<String>(value: "")
    var displayName = BehaviorRelay<String>(value: "")
    var email = BehaviorRelay<String>(value: "")
    var company = BehaviorRelay<String>(value: "")
    var jobTitle = BehaviorRelay<String>(value: "")
    
    // MARK: - Validate Values
    
    func validateValues() throws -> Bool {
        
        // Name Validation
        guard !(firstName.value.trim().isEmpty) else {
            throw ValidateError.invalidData(.EmptyFirstName)
        }
        guard !(lastName.value.trim().isEmpty) else {
            throw ValidateError.invalidData(.EmptyLastName)
        }
        
        // Email Validation
        guard !(email.value.trim().isEmpty) else {
            throw ValidateError.invalidData(.EmptyEmail)
        }
        guard isValidEmailAddress(email: email.value.trim()) else {
            throw ValidateError.invalidData(.InvalidEmail)
        }
        
        return true
    }
    
    // MARK: - Validate & Create Contact
    
    func validateAndCreateContact(completion: actionHandler) {
        do {
            if try validateValues() {
                completion(true, .Success)
            }
        } catch ValidateError.invalidData(let message) {
            completion(false, message)
        } catch {
            completion(false, .UnknownError)
        }
    }
    
    // MARK: - NetReq Create Contact
    
    func netReqCreateContact(completion: @escaping completionHandler) {
        
        // Check Internet
        guard Connectivity.isConnectedToInternet() else {
            completion(false, 503, .NoInternetConnection)
            return
        }
        
        
    }
}
