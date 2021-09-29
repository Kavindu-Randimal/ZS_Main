//
//  SignatureVM.swift
//  ZorroSign
//
//  Created by Mathivathanan on 2021-01-09.
//  Copyright © 2021 Apple. All rights reserved.
//

import Foundation

enum CellType: Int {
    case HandWritten = 0, ComputerGenerated = 1, UploadSignature = 2
}

enum SignaturePart {
    case Initial, Signature
}

enum SignatureType: String {
    case HandWritten = "hr"
    case ComputerGenerated = "cg"
    case UploadSignature = "uu"
}

struct UploadSignature {
    var imgInitial: UIImage?
    var imgSignature: UIImage?
}

class SignatureVM: NSObject {
    
    // MARK: - Variables
    
    var userProfile = UserProfile()
    var defaultSignature: UserSettings?
    var arrOptionalSignatures: [UserSignature]?
    
    var userSignatureUpdate = UserSignatureUpdate()
    
    // Current Signature
    var currentSignature: UserSignature?
    var localUploadSignatureImages = UploadSignature()
    
    // Edit
    var isEditingOldSignature: Bool = false
    var selectedSignatureToEdit: SignatureNo?
    
    // MARK: - Signature Validation
    
    func validateSignatures() throws -> Bool {
        
        guard let _currentSignature = currentSignature else {
            throw ValidateError.invalidData("Please add a Signature & Initial")
        }
        
        guard _currentSignature.Initials != nil else {
            throw ValidateError.invalidData("Please add a Initial")
        }
        
        guard _currentSignature.Signature != nil else {
            throw ValidateError.invalidData("Please add a Signature")
        }
        
        return true
    }
    
    func validateAndUpdateSignature(completion: actionHandler) {
        do {
            if try validateSignatures() {
                completion(true, "Success")
            }
        } catch ValidateError.invalidData(let message) {
            completion(false, message)
        } catch {
            completion(false, "Invalid")
        }
    }
    
    
    // MARK: - NetReq Get Signature Details
    
//    func getProfiledata(completion: @escaping completionHandler) {
//
//        // Chechk Internet
//        guard Connectivity.isConnectedToInternet() else {
//            completion(false, 503, "No internet connection")
//            return
//        }
//
//        userProfile.getuserprofileData(completion:{ (profiledata, status) in
//            if let _profiledata = profiledata {
//                self.userSignatures = _profiledata.Data?.UserSignatures
//                completion(true, 200, "Success")
//            } else {
//                completion(false, 700, "Error")
//            }
//        })
//    }
    
    // MARK: - Prep the Array to Upload
    
    func prepSignatureArray() {
        
        // Scenario - This is the First Signature
        /// If Both default and optionalSignatures empty, Then Current Signature is the default
        if defaultSignature == nil && arrOptionalSignatures == nil {
            arrOptionalSignatures = []
            currentSignature?.IsDefault = true
            currentSignature?.IsDeleted = false
            
            if let _currentSignature = currentSignature {
                arrOptionalSignatures?.append(_currentSignature)
            }
        }
        
        /// Check for Existing Default Signature and appending it to the arrray.
        if let _defaultSignature = defaultSignature {
            var defaultSignature = UserSignature()
            defaultSignature.IsDefault = true
            defaultSignature.IsDeleted = false
            defaultSignature.Signature = _defaultSignature.signatureImage
            defaultSignature.Initials = _defaultSignature.initialImage
            defaultSignature.Settings = _defaultSignature
            
            if arrOptionalSignatures != nil {
                // Scenario - There are optional Signatures
                arrOptionalSignatures?.append(defaultSignature)
            } else {
                // Scenario - There's only one Signature, And that is Default
                arrOptionalSignatures = []
                arrOptionalSignatures?.append(defaultSignature)
            }
            
            /// Appending the current Signature
            if var _currentSignature = currentSignature {
                _currentSignature.IsDeleted = false
                _currentSignature.IsDefault = false
                arrOptionalSignatures?.append(_currentSignature)
            }
        } else {
            /// If Default Signature null, That means current signature will be the Default one.
            if let _currentSignature = currentSignature {
                currentSignature?.IsDefault = true
                currentSignature?.IsDeleted = false
                
                if arrOptionalSignatures != nil {
                    // Scenario - There are optional Signatures
                    arrOptionalSignatures?.append(_currentSignature)
                } else {
                    // Scenario - There's only one Signature, And that is Default
                    arrOptionalSignatures = []
                    arrOptionalSignatures?.append(_currentSignature)
                }
            }
        }
        
        // Setting Default values
        if let _arrOptionalSignatures = arrOptionalSignatures {
            for i in 0..<_arrOptionalSignatures.count {
                arrOptionalSignatures?[i].Settings?.signatureWidth = 500
                arrOptionalSignatures?[i].Settings?.signatureHeight = 100
                arrOptionalSignatures?[i].Settings?.initialWidth = 100
                arrOptionalSignatures?[i].Settings?.initialHeight = 100
                
                setDefaultValuesIfNull(index: i)
            }
        }
    }
    
    // MARK: - Set Default Values IfNull
    
    func setDefaultValuesIfNull(index: Int) {
        
        arrOptionalSignatures?[index].SignatureDescription = SignatDescription(DescriptionKey: "", DescriptionText: "", DescriptionValue: "", Reason: "")
        
        // usersignature id
//        if arrOptionalSignatures?[index].UserSignatureId == nil {
//            arrOptionalSignatures?[index].UserSignatureId = 0
//        }
        
        // signaturetext
        if arrOptionalSignatures?[index].Settings?.signaturetext == nil {
            arrOptionalSignatures?[index].Settings?.signaturetext = ""
        }
        
        // initialtext
        if arrOptionalSignatures?[index].Settings?.initialtext == nil {
            arrOptionalSignatures?[index].Settings?.initialtext = ""
        }
        
        // editProfilesignFont
        if arrOptionalSignatures?[index].Settings?.editProfilesignFont == nil {
            arrOptionalSignatures?[index].Settings?.editProfilesignFont = ""
        }
        
        // editProfilesignFontsize
        if arrOptionalSignatures?[index].Settings?.editProfilesignFontsize == nil {
            arrOptionalSignatures?[index].Settings?.editProfilesignFontsize = ""
        }
        
        // editProfileinitFont
        if arrOptionalSignatures?[index].Settings?.editProfileinitFont == nil {
            arrOptionalSignatures?[index].Settings?.editProfileinitFont = ""
        }
        
        // editProfileinitFontsize
        if arrOptionalSignatures?[index].Settings?.editProfileinitFontsize == nil {
            arrOptionalSignatures?[index].Settings?.editProfileinitFontsize = ""
        }
        
        // signaturePath
        if arrOptionalSignatures?[index].Settings?.signaturePath == nil {
            arrOptionalSignatures?[index].Settings?.signaturePath = []
        }
        
        // initialPath
        if arrOptionalSignatures?[index].Settings?.initialPath == nil {
            arrOptionalSignatures?[index].Settings?.initialPath = []
        }
        
        // signatureIsolatedPoints
        if arrOptionalSignatures?[index].Settings?.signatureIsolatedPoints == nil {
            arrOptionalSignatures?[index].Settings?.signatureIsolatedPoints = []
        }
        
        // initialIsolatedPoints
        if arrOptionalSignatures?[index].Settings?.initialIsolatedPoints == nil {
            arrOptionalSignatures?[index].Settings?.initialIsolatedPoints = []
        }
        
        // penWidth
        if arrOptionalSignatures?[index].Settings?.penWidth == nil {
            arrOptionalSignatures?[index].Settings?.penWidth = 0
        }
        
        // penColor
        if arrOptionalSignatures?[index].Settings?.penColor == nil {
            arrOptionalSignatures?[index].Settings?.penColor = "rgb(0,0,0)"
        }
        
        // penColorSliderPosition
        if arrOptionalSignatures?[index].Settings?.penColorSliderPosition == nil {
            arrOptionalSignatures?[index].Settings?.penColorSliderPosition = 0
        }
    }
    
    // MARK: - NetReq Save Signature Details
    
    func netReqUpdateSignature(completion: @escaping completionHandler) {
        
        // Chechk Internet
        guard Connectivity.isConnectedToInternet() else {
            completion(false, 503, "No internet connection")
            return
        }
        
        prepSignatureArray()
        
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
