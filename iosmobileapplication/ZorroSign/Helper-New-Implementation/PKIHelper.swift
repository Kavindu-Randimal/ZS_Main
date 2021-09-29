//
//  KeyGenerator.swift
//  ZorroSign
//
//  Created by Anuradh Caldera on 11/20/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import Foundation
import UIKit
import CommonCrypto

struct PKIHelper {
    private var status: OSStatus?
    private var publicKey: SecKey?
    private var privateKey: SecKey?
}

//MARK: - Generate key Pair (public, private) using RSA
extension PKIHelper {
    mutating func generateKeyPair(keyid: String, completion: @escaping(Bool, String?) -> ()) {
        
        let publickeyTag = (ZorroTempStrings.ZORRO_PKI_PUBLICK_KEY + keyid).data(using: .utf8)! as NSObject
        let privatekeyTag = (ZorroTempStrings.ZORRO_PKI_PRIVATE_KEY + keyid).data(using: .utf8)! as NSObject
        
        
        let publicKeyAttributes: [NSObject: NSObject] = [
            kSecAttrIsPermanent: true as NSObject,
            kSecAttrApplicationTag: publickeyTag,
            kSecClass: kSecClassKey,
            kSecReturnData: kCFBooleanTrue
        ]
        
        let privateKeyAttributes: [NSObject: NSObject] = [
            kSecAttrIsPermanent: true as NSObject,
            kSecAttrApplicationTag: privatekeyTag,
            kSecClass: kSecClassKey,
            kSecReturnData: kCFBooleanTrue
        ]
        
        var keypairAttributes = [NSObject: NSObject]()
        keypairAttributes[kSecAttrKeyType] = kSecAttrKeyTypeRSA
        keypairAttributes[kSecAttrKeySizeInBits] = 2048 as NSObject
        keypairAttributes[kSecPublicKeyAttrs] = publicKeyAttributes as NSObject
        keypairAttributes[kSecPrivateKeyAttrs] = privateKeyAttributes as NSObject
        
        let status: OSStatus = SecKeyGeneratePair(keypairAttributes as CFDictionary, &publicKey, &privateKey)
        
        if status == noErr && publicKey != nil && privateKey != nil {
            
            var _resultPublickKey: AnyObject?
            var _resultPrivateKey: AnyObject?
            
            let statusPublic: OSStatus = SecItemCopyMatching(publicKeyAttributes as CFDictionary, &_resultPublickKey)
            let statusPrivate: OSStatus = SecItemCopyMatching(privateKeyAttributes as CFDictionary, &_resultPrivateKey)
            
            if statusPublic == noErr && statusPrivate == noErr {
                if let _publickeydata = _resultPublickKey as? Data, let _privatekeydata = _resultPrivateKey as? Data {
                    
                    let _publickeyBase64 = _publickeydata.base64EncodedString()
                    let _privatekeyBase64 = _privatekeydata.base64EncodedString()
                    
                    // Save To KeyChain
                    KeyChainWrapper.saveToKeyChain(service: ZorroTempStrings.ZORRO_PUBLIC_KEY + keyid, account: ZorroTempStrings.ZORRO_KEYCHAIN_ACCOUNT, value: _publickeyBase64) { success in
                        
                        if success {
                            KeyChainWrapper.saveToKeyChain(service: ZorroTempStrings.ZORRO_PRIVATE_KEY + keyid, account: ZorroTempStrings.ZORRO_KEYCHAIN_ACCOUNT, value: _privatekeyBase64) { (_success) in
                                
                                if _success {
                                    completion(_success, _publickeyBase64)
                                    return
                                }
                                completion(_success, nil)
                                return
                            }
                            return
                        }
                        completion(success, nil)
                        return
                    }
                    return
                }
                completion(false, nil)
                return
            }
            completion(false, nil)
            return
        }
        completion(false, nil)
        return
    }
}

//MARK: - Encrypt Data Using Public Key
extension PKIHelper {
    mutating func encryptWithPublicKey(textIn text: String) -> String {
        
        if let _publickeyData: Data = Data(base64Encoded: "MIIBCgKCAQEAkfh2upQyJsu3oy/ouRIH88wok3jdPf/uv1gSrmkwJpJhlZ8JGezd6uxOVoUD+hNsRHjniiLqCNJLnsq6QS2pzEsufpLMD+hJ+dsreioJdxuUHHt4Ps2ocIc6pA+fG6McXmtESH7geLVBe07iwzmUEMLk6nGls31sgfYIbXuSIO41wdCaYVuxciHPWzdv5/WPniTgISFNfhGAHVY4XPkv0JfuGHodBe2x9DPshaYiCIiybaOs/QfzAo29y/RxiTHvVIj/ioWEd8QQ1kfLP9wW/gCQPySBM9kHAHkIJ3/2idpW6OM780x/4S2aPP6kyuoiKreLh+nvGa8XG0mcMKaNtwIDAQAB") {
            
            let keyDictionary: [NSObject: NSObject] = [
                kSecAttrKeyType: kSecAttrKeyTypeRSA,
                kSecAttrKeyClass: kSecAttrKeyClassPublic,
                kSecAttrKeySizeInBits: 2048 as NSObject,
                kSecReturnPersistentRef: true as NSObject
            ]
            
            let _publicSecKey: SecKey = SecKeyCreateWithData(_publickeyData as CFData, keyDictionary as CFDictionary, nil)!
            
            // encrypt the message
            let blocksize = SecKeyGetBlockSize(_publicSecKey)
            var messageEncrypted = [UInt8](repeating: 0, count: blocksize)
            var messageEncryptedSize = blocksize
            
            status = SecKeyEncrypt(_publicSecKey, .PKCS1, text, text.count, &messageEncrypted, &messageEncryptedSize)
            
            if status != noErr {
                print("Error while encryption")
                return ""
            }
            
            let encryptedData = Data(bytes: &messageEncrypted, count: blocksize)
            let encryptedBase64 = encryptedData.base64EncodedString()
            print("Encrypted Base64 -> : ", encryptedBase64)
            
            let _: [UInt8] = messageEncrypted
            
            let cdedata = Data(base64Encoded: encryptedBase64)
            let _ : [UInt8] = Array(cdedata!)
            
            return encryptedBase64
        }
        return ""
        
    }
}

extension PKIHelper {
    func decryptWithPrivateKey(keyid: String, encryptedText: String, completion: @escaping(String?) -> ()){
        
        let decodeddata = Data(base64Encoded: encryptedText)
        let decodedstring = String(data: decodeddata!, encoding: .utf8)
        
        var servicename = ZorroTempStrings.ZORRO_PUBLIC_KEY
        if keyid != "" {
            servicename = ZorroTempStrings.ZORRO_PUBLIC_KEY + keyid
        }
        
        KeyChainWrapper.getFromKeyChain(service: servicename, account: ZorroTempStrings.ZORRO_KEYCHAIN_ACCOUNT) { (publickeybase64) in
            
            guard let publickeyBase64 = publickeybase64 else {
                completion(nil)
                return
            }
            
            if let publickeydata: Data = Data(base64Encoded: publickeyBase64) {
                
                let keyDictionary: [NSObject: NSObject] = [
                    kSecAttrKeyType: kSecAttrKeyTypeRSA,
                    kSecAttrKeyClass: kSecAttrKeyClassPublic,
                    kSecAttrKeySizeInBits: 2048 as NSObject,
                    kSecReturnPersistentRef: true as NSObject
                ]
                
                let publicSecKey: SecKey = SecKeyCreateWithData(publickeydata as CFData, keyDictionary as CFDictionary, nil)!
                
                let blocksize = SecKeyGetBlockSize(publicSecKey)
                var messagedecrypted = [UInt8](repeating: 0, count: blocksize)
                var messagedecryptedsize = blocksize
                
                var privateservicename = ZorroTempStrings.ZORRO_PRIVATE_KEY
                if keyid != "" {
                    privateservicename = ZorroTempStrings.ZORRO_PRIVATE_KEY + keyid
                }
                
                KeyChainWrapper.getFromKeyChain(service: privateservicename, account: ZorroTempStrings.ZORRO_KEYCHAIN_ACCOUNT) { (privatekeybase64) in
                    
                    guard let privatekeyBase64 = privatekeybase64 else {
                        return
                    }
                    
                    if let privatekeydata: Data = Data(base64Encoded: privatekeyBase64) {
                        
                        let keyDictionary: [NSObject: NSObject] = [
                            kSecAttrKeyType: kSecAttrKeyTypeRSA,
                            kSecAttrKeyClass: kSecAttrKeyClassPrivate,
                            kSecAttrKeySizeInBits: 2048 as NSObject,
                            kSecReturnPersistentRef: true as NSObject
                        ]
                        
                        let privateSecKey: SecKey = SecKeyCreateWithData(privatekeydata as CFData, keyDictionary as CFDictionary, nil)!
                        
                        
                        let encrypteddata = Data(base64Encoded: encryptedText)
                        let encryptedmessage: [UInt8] = Array(encrypteddata!)
                        
                        
                        var _status: OSStatus!
                        
                        _status = SecKeyDecrypt(privateSecKey, .PKCS1, encryptedmessage, messagedecryptedsize, &messagedecrypted, &messagedecryptedsize)
                        
                        if _status != noErr {
                            print("Error while encryption")
                            completion(nil)
                            return
                        }
                        
                        let decryptedData = Data(bytes: &messagedecrypted, count: blocksize)
                        _ = decryptedData.base64EncodedString()
                        
                        print(NSString(bytes: &messagedecrypted, length: messagedecryptedsize, encoding: String.Encoding.utf8.rawValue)!)
                        
                        let decryptedString = NSString(bytes: &messagedecrypted, length: messagedecryptedsize, encoding: String.Encoding.utf8.rawValue)!
                        
                        completion(decryptedString as String)
                        return
                    }
                }
            }
        }
    }
}

//MARK: - Signed Data Using Private Key
extension PKIHelper {
    func signWithPrivateKey(textIn text: String, keyid: String, completion: @escaping(Bool, String?) -> ()) {
        
        var servicename = ZorroTempStrings.ZORRO_PRIVATE_KEY
        if keyid != "" {
            servicename = ZorroTempStrings.ZORRO_PRIVATE_KEY + keyid
        }
        
        KeyChainWrapper.getFromKeyChain(service: servicename, account: ZorroTempStrings.ZORRO_KEYCHAIN_ACCOUNT) { (_privatekeyBase64) in
            
            guard let _privatekeyBase64 = _privatekeyBase64 else {
                completion(false, nil)
                return
            }
            
            if let _privatekeyData: Data = Data(base64Encoded: _privatekeyBase64) {
                
                let keyDictionary: [NSObject: NSObject] = [
                    kSecAttrKeyType: kSecAttrKeyTypeRSA,
                    kSecAttrKeyClass: kSecAttrKeyClassPrivate,
                    kSecAttrKeySizeInBits: 2048 as NSObject,
                    kSecReturnPersistentRef: true as NSObject
                ]
                
                var error: Unmanaged<CFError>?
                
                let _privateSecKey: SecKey = SecKeyCreateWithData(_privatekeyData as CFData, keyDictionary as CFDictionary, nil)!
                
                
                if let _testdata = SecKeyCopyExternalRepresentation(_privateSecKey, &error) as Data? {
                    print(_testdata.base64EncodedString())
                }
                
                if error != nil {
                    print(error ?? "Error in Signed Process")
                    completion(false, nil)
                    return
                }
                
                guard let signedText = self.signWithPrivate(text, _privateSecKey) else {
                    completion(false, nil)
                    return
                }
                print(signedText)
                completion(true, signedText)
                return
            }
            completion(false, nil)
            return
        }
        return
    }
}

//MARK: - Private method to sign
extension PKIHelper {
    private func signWithPrivate(_ text: String, _ key: SecKey) -> String? {
        var digest = Data(count: Int(CC_SHA256_DIGEST_LENGTH))
        let data = text.data(using: .utf8)!
        
        let _ = digest.withUnsafeMutableBytes { digestBytes in
            data.withUnsafeBytes { dataBytes in
                CC_SHA256(dataBytes, CC_LONG(data.count), digestBytes)
            }
        }
        
        var signature = Data(count: SecKeyGetBlockSize(key) * 4)
        var signatureLength = signature.count
        
        let result = signature.withUnsafeMutableBytes { signatureBytes in
            digest.withUnsafeBytes { digestBytes in
                SecKeyRawSign(key,
                              SecPadding.PKCS1SHA256,
                              digestBytes,
                              digest.count,
                              signatureBytes,
                              &signatureLength)
            }
        }
        
        let count = signature.count - signatureLength
        signature.removeLast(count)
        
        guard result == noErr else {
            print("Error Occured")
            return nil
        }
        return signature.base64EncodedString()
    }
}

//MARK: - Generate CSR - Certificate Signin Request
extension PKIHelper {
    func generateCSR(keyid: String, countryName: String, CommonName: String, Organization: String, SerialName: String) {
        
        let csr = CertificateSigningRequest(commonName: "test name", organizationName: "ZorroSign", organizationUnitName: "ZorrosignCryptp", countryName: "USA", stateOrProvinceName: "Texas", localityName: "abc", keyAlgorithm: .rsa(signatureType: .sha256))
        
        KeyChainWrapper.getFromKeyChain(service: ZorroTempStrings.ZORRO_PUBLIC_KEY, account: ZorroTempStrings.ZORRO_KEYCHAIN_ACCOUNT) { (publickkeystring) in
            
            if let publickkeydata = Data(base64Encoded: publickkeystring ?? "") {
                
                KeyChainWrapper.getFromKeyChain(service: ZorroTempStrings.ZORRO_PRIVATE_KEY, account: ZorroTempStrings.ZORRO_KEYCHAIN_ACCOUNT) { (privatekeystring) in
                    
                    
                    if let privatekeydata = Data(base64Encoded: privatekeystring ?? "") {
                        
                        let keyDictionary: [NSObject: NSObject] = [
                            kSecAttrKeyType: kSecAttrKeyTypeRSA,
                            kSecAttrKeyClass: kSecAttrKeyClassPrivate,
                            kSecAttrKeySizeInBits: 2048 as NSObject,
                            kSecReturnPersistentRef: true as NSObject
                        ]
                        
                        let _privateSecKey: SecKey = SecKeyCreateWithData(privatekeydata as CFData, keyDictionary as CFDictionary, nil)!
                        
                        let csrstring = csr.buildCSRAndReturnString(publickkeydata, privateKey: _privateSecKey)
                        print(csrstring ?? "")
                    }
                }
            }
        }
    }
}
