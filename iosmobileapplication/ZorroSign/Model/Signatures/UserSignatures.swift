//
//  UserSignatures.swift
//  ZorroSign
//
//  Created by Apple on 18/07/18.
//  Copyright © 2018 Apple. All rights reserved.
//

import Foundation

@objc class UserSignatures: WSBaseData {
    
    var Signature: String?
    var Initials: String?
    var SignatureDescription: SignatureDescription?
    var settings:Settings?
    var IsDefault: Bool?
    var IsDeleted: Bool?
    var UserSignatureId:Int?
    
    
    
    override func populate(fromDictionary dict: NSDictionary) {
        super.populate(fromDictionary: dict)
        
        if let settingsDic = dict.object(forKey: "Settings") as?  [AnyHashable : Any] {
            
            self.settings = Settings(dictionary: settingsDic)
        }
        if let usersignid = dict.object(forKey: "UserSignatureId") as? Int{
            self.UserSignatureId = usersignid
        }
    }
    
    func convertToSignObject(cnt: Int) -> SignObject{
        
        let signObj = SignObject()
        
        if let signType = self.settings?.signatureType, signType != "<null>" && (signType == "cg" || signType == "hr") {
            if !signType.isEmpty {
                let index = Singletone.shareInstance.signOptDict.index(of: signType)
                signObj.signOpt = Singletone.shareInstance.signOptArray[index!]
            }
            else {
                signObj.signOpt = Singletone.shareInstance.signOptArray[0]
            }
            signObj.signDisp = (signObj.signDisp != nil) ? signObj.signDisp : (self.settings?.signaturetext ?? "")
            signObj.signFont = self.settings?.editProfilesignFont ?? ""
            
            //signObj.signFontSize = self.Settings?.editProfilesignFontsize
            signObj.signColor = self.settings?.PenColor?.rgbToColor() ?? UIColor.black
            //UIColor(hex: (self.Settings?.PenColor)!) ?? UIColor.black
            if let signpath = self.settings?.signaturePath {
                signObj.signPathArr = signpath
            }
            
        } else {
            signObj.signOpt = Singletone.shareInstance.signOptArray[0]
            signObj.signFont = ""
            signObj.signColor = UIColor.black
        }
        if let iniType = self.settings?.initialType, iniType != "<null>" && (iniType == "cg" || iniType == "hr")  {
            if !iniType.isEmpty {
                let index = Singletone.shareInstance.signOptDict.index(of: iniType)
                signObj.initialOpt = Singletone.shareInstance.signOptArray[index!]
            }
            else {
                signObj.initialOpt = Singletone.shareInstance.signOptArray[0]
            }
            if let inipath = self.settings?.initialPath {
                signObj.initialPathArr = inipath
            }
            
            signObj.signColor = self.settings?.PenColor?.rgbToColor() ?? UIColor.black
            signObj.initialFont = self.settings?.editProfileinitFont ?? ""
            //signObj.initialDisp = self.settings?.initialtext ?? ""
            signObj.initialDisp = (signObj.initialDisp != nil) ? signObj.initialDisp : (self.settings?.initialtext ?? "")
            
        } else {
            signObj.initialOpt = Singletone.shareInstance.signOptArray[0]
            signObj.signColor = UIColor.black
            signObj.initialFont = ""
            //signObj.initialDisp = ""
        }
        
        let FullName = UserDefaults.standard.string(forKey: "FullName")
        let fName: String = UserDefaults.standard.string(forKey: "FName")!
        let lName: String = UserDefaults.standard.string(forKey: "LName")!
        let f1: String = String(fName.prefix(1))
        let l1: String = String(lName.prefix(1))
        
        let initial = "\(f1) \(l1)"
        
        
        if signObj.signDisp == nil {
            if let signtext = self.settings?.signaturetext {
                signObj.signDisp = signtext
            } else {
                if cnt == 0 {
                    signObj.signDisp = FullName ?? ""
                }
                else {
                    signObj.signDisp = ""
                }
            }
        }
        
        if signObj.initialDisp == nil {
            if let initext = self.settings?.initialtext {
                signObj.initialDisp = initext
            } else {
                if cnt == 0 {
                    signObj.initialDisp = initial
                }
                else {
                    signObj.initialDisp = ""
                }
            }
        }
        
        if let signimg = self.Signature {
            signObj.signature = signimg
        } else if let signimg = self.settings?.signatureImage {
            signObj.signature = signimg
        }
        if let initimg = self.Initials {
            signObj.initials = initimg
            
        } else if let initimg = self.settings?.initialImage {
            signObj.initials = initimg
        }
        if let penWidth = self.settings?.penWidth {
            signObj.signFontSize = CGFloat(penWidth * 10)
        } else {
            signObj.signFontSize = 1
        }
        
        signObj.saveOpt = self.SignatureDescription?.DescriptionText ?? "Saving as"
        signObj.saveOptVal1 = self.SignatureDescription?.DescriptionValue ?? ""
        signObj.saveOptVal2 = self.SignatureDescription?.Reason ?? ""
        signObj.isDefault = self.IsDefault ?? false
        
        if let usersignid = self.UserSignatureId {
            signObj.userSignId = String(usersignid)
        }
        
        return signObj
    }
}
