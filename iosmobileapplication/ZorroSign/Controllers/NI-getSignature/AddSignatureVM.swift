//
//  SignatureSelectVM.swift
//  ZorroSign
//
//  Created by CHATHURA ELLAWALA on 2021-01-24.
//  Copyright © 2021 Apple. All rights reserved.
//

import Foundation

enum SignatureNo: Int {
    case One = 1
    case Two = 2
    case Three = 3
}

class AddSignatureVM: NSObject {
    
    // MARK: - Variables
    
    var userProfile = UserProfile()
    var defaultSignature: UserSettings?
    var arrOptionalSignatures: [UserSignature]?
    
    var signatureCount: Int = 0
    
    var userSignatureUpdate = UserSignatureUpdate()
    
    // MARK: - Set the array for Default Signature Changes
    
    func prepareSignArrayForDefaultChanges(selectedIndex: Int) {
        
        // Create UserSignature object for the existing default signature
        var existingDefaultSignature = UserSignature()
        existingDefaultSignature.Settings = defaultSignature
        existingDefaultSignature.Initials = defaultSignature?.initialImage
        existingDefaultSignature.Signature = defaultSignature?.signatureImage
        existingDefaultSignature.IsDefault = false
        existingDefaultSignature.IsDeleted = false
        existingDefaultSignature.SignatureDescription = SignatDescription(DescriptionKey: "", DescriptionText: "", DescriptionValue: "", Reason: "")
        
        // set the selected Signature as Default Signature
        arrOptionalSignatures?[selectedIndex].IsDefault = true
        
        arrOptionalSignatures?.append(existingDefaultSignature)
    }
    
    // MARK: - Revert Back the array
    
    func revertBackToOriginalArray(selectedIndex: Int) {
        arrOptionalSignatures?[selectedIndex].IsDefault = false
        
        // Removing the added Locally created Default Signature
        arrOptionalSignatures?.removeLast()
    }
    
    // MARK: - Prep the Array to Upload in DELETE
    
    func prepareSignArray(signatureNo: Int, completion: @escaping(_ isDeleted: Bool) -> ()) {
        
        if signatureNo == SignatureNo.One.rawValue {
            
            // if it's a default signature
            if arrOptionalSignatures != nil {
                // if has optional signatures
                if arrOptionalSignatures!.count > 0 {
                    // has optional signatures
                    arrOptionalSignatures?[0].IsDefault = true
                    completion(true)
                } else {
                    // optional signature array is empty
                    completion(false)
                }
            } else {
                // if no any optional signatures
                completion(false)
            }
        } else {
            
            // if it's an optional signature
            if arrOptionalSignatures != nil {
                arrOptionalSignatures?.remove(at: signatureNo - 2)
                
                // add the default signature
                if let _defaultSignature = defaultSignature {
                    var defaultSignature = UserSignature()
                    defaultSignature.IsDefault = true
                    defaultSignature.IsDeleted = false
                    defaultSignature.Signature = _defaultSignature.signatureImage
                    defaultSignature.Initials = _defaultSignature.initialImage
                    defaultSignature.Settings = _defaultSignature
                    
                    arrOptionalSignatures?.append(defaultSignature)
                    completion(true)
                }
            }
        }
    }
    
    // MARK: - NetReq Get Signature Details
    
    func getProfiledata(completion: @escaping completionHandler) {
        
        // Check Internet
        guard Connectivity.isConnectedToInternet() else {
            completion(false, 503, "No internet connection")
            return
        }
        
        userProfile.getuserprofileData(completion:{ (profiledata, err) in
            if let _profiledata = profiledata, let _defaultSignature = _profiledata.Data?.Settings {
                self.userProfile = _profiledata
                self.defaultSignature = _defaultSignature
                
                //Assign Signature in Data for signatureImage in Settings when signatureimge is nil
                if self.defaultSignature?.signatureImage == nil {
                    if _profiledata.Data?.Signature != nil {
                        self.defaultSignature?.signatureImage = _profiledata.Data?.Signature
                    }
                }
                
                //Assign Initials in Data for initialImage in Settings when initialImage is nil
                if self.defaultSignature?.initialImage == nil {
                    if _profiledata.Data?.Initials != nil {
                        self.defaultSignature?.initialImage = _profiledata.Data?.Initials
                    }
                }
                
                if let _arrOptionalSignatures = _profiledata.Data?.UserSignatures {
                    self.arrOptionalSignatures = _arrOptionalSignatures
                    
                    self.signatureCount = 1 + _arrOptionalSignatures.count
                } else {
                    self.arrOptionalSignatures = nil
                    self.signatureCount = 1
                }
                
                completion(true, 200, "Success")
            } else {
                if !err {
                    completion(true, 200, "Success")
                } else {
                    completion(false, 400, "Error")
                }
            }
        })
    }
    
    // MARK: - NetReq Save Signature Details
    
    func updateSignature(completion: @escaping completionHandler) {
        
        // Chechk Internet
        guard Connectivity.isConnectedToInternet() else {
            completion(false, 503, "No internet connection")
            return
        }
        
        userSignatureUpdate.ProfileId = ZorroTempData.sharedInstance.getProfileId()
        userSignatureUpdate.PinCode = ""
        userSignatureUpdate.UserSignatures = arrOptionalSignatures
        
        userSignatureUpdate.updateusersignatureData(usersignatureupdate: userSignatureUpdate, completion: { (success, errmsg, statuscode) in
            if success {
                completion(true, statuscode, "Success")
            } else {
                completion(false, statuscode, "Failure")
            }
        })
    }
    
    // MARK: - NetReq Save Signature Details
    
    func netReqUpdateSignature(completion: @escaping completionHandler) {
        
        // Chechk Internet
        guard Connectivity.isConnectedToInternet() else {
            completion(false, 503, "No internet connection")
            return
        }
        
        userSignatureUpdate.ProfileId = ZorroTempData.sharedInstance.getProfileId()
        userSignatureUpdate.PinCode = ""
        userSignatureUpdate.UserSignatures = arrOptionalSignatures
        
        userSignatureUpdate.updateusersignatureData(usersignatureupdate: userSignatureUpdate, completion: { (success, errmsg, statuscode) in
            if success {
                completion(true, statuscode, "Success")
            } else {
                completion(false, statuscode, errmsg ?? "Unknown")
            }
        })
    }
}
