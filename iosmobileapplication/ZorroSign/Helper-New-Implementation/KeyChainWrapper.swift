//
//  KeyChainWrapper.swift
//  ZorroSign
//
//  Created by Anuradh Caldera on 11/19/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import Foundation
import Security

let kSecClassValue = NSString(format: kSecClass)
let kSecAttrAccountValue = NSString(format: kSecAttrAccount)
let kSecValueDataValue = NSString(format: kSecValueData)
let kSecClassGenericPasswordValue = NSString(format: kSecClassGenericPassword)
let kSecAttrServiceValue = NSString(format: kSecAttrService)
let kSecMatchLimitValue = NSString(format: kSecMatchLimit)
let kSecReturnDataValue = NSString(format: kSecReturnData)
let kSecMatchLimitOneValue = NSString(format: kSecMatchLimitOne)

class KeyChainWrapper: NSObject { }

//MARK: - Save To KeyChain
extension KeyChainWrapper {
    class func saveToKeyChain(service: String, account: String, value: String, completion: @escaping(Bool) -> ()) {
            
        if let data = value.data(using: String.Encoding.utf8, allowLossyConversion: false) {
            
            let keychainQuery: NSMutableDictionary = NSMutableDictionary(objects: [kSecClassGenericPasswordValue, service, account, data], forKeys: [kSecClassValue, kSecAttrServiceValue, kSecAttrAccountValue, kSecValueDataValue])
            
            let status: OSStatus = SecItemAdd(keychainQuery as CFDictionary, nil)
          
            if status != errSecSuccess {
                print("Error Occured")
                completion(false)
                return
            }
            completion(true)
            return
        }
    }
}

//MARK: - Get From KeyChain
extension KeyChainWrapper {
    class func getFromKeyChain(service: String, account: String, completion: @escaping(String?) -> ()) {
        
        let keychainQuery: NSMutableDictionary = NSMutableDictionary(objects: [kSecClassGenericPassword, service, account, kCFBooleanTrue, kSecMatchLimitOneValue], forKeys: [kSecClassValue, kSecAttrServiceValue, kSecAttrAccountValue, kSecReturnDataValue, kSecMatchLimitValue])
        
        var dataTypeRef: AnyObject?
        
        let status: OSStatus = SecItemCopyMatching(keychainQuery, &dataTypeRef)
        var value: String?
        
        if status != errSecSuccess {
            completion(nil)
            return
        }
        
        if let data = dataTypeRef as? Data {
            value = String(data: data, encoding: .utf8)
            completion(value)
            return
        }
        completion(nil)
        return
    }
}

//MARK: - Update In Keychain
extension KeyChainWrapper {
    class func upInKeyChain(service: String, account: String, value: String, completion: @escaping(Bool) -> ()) {
        
        if let data: Data = value.data(using: String.Encoding.utf8, allowLossyConversion: false) {
                
            let keychainQuery: NSMutableDictionary = NSMutableDictionary(objects: [kSecClassGenericPassword, service, account, ], forKeys: [kSecClassValue, kSecAttrServiceValue, kSecAttrAccountValue, kSecValueDataValue])
            
            let status: OSStatus = SecItemUpdate(keychainQuery as CFDictionary, [kSecValueDataValue: data] as CFDictionary)
            
            if status != errSecSuccess {
                completion(false)
                return
            }
            completion(true)
            return
        }
    }
}

//MARK: - Delete From Keychain
extension KeyChainWrapper {
    class func deleteFromKeyChain(service: String, account: String) {
            
        let keychainQuery: NSMutableDictionary = NSMutableDictionary(objects: [kSecClassGenericPassword, service, account], forKeys: [kSecClassValue, kSecAttrServiceValue, kSecAttrAccountValue])
        
        let status: OSStatus = SecItemDelete(keychainQuery as CFDictionary)
        if status != errSecSuccess {
            return
        }
        return
    }
}

