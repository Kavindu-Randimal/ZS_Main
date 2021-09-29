//
//  Settings.swift
//  ZorroSign
//
//  Created by Apple on 18/07/18.
//  Copyright © 2018 Apple. All rights reserved.
//

import Foundation

@objc class Settings:WSBaseData {
    
    var signatureImage:String = ""
    var initialImage:String = ""
    var signatureType:String = ""
    var initialType:String = ""
    var signaturetext:String?
    var initialtext:String?
    var editProfilesignFont:String?
    var editProfilesignFontsize:String?
    var editProfileinitFont:String?
    var editProfileinitFontsize:String?
    var signaturePath:[SignaturePath]?
    var initialPath:[SignaturePath]?
    var signatureIsolatedPoints:CGPoint?
    var initialIsolatedPoints:CGPoint?
    var penWidth:Int?
    var PenColor:String?
    var penColorSliderPosition:Int?
    var signatureWidth:Int?
    var signatureHeight:Int?
    var initialWidth:Int?
    var initialHeight:Int?
    
    override func populate(fromDictionary dict: NSDictionary) {
        super.populate(fromDictionary: dict)
        
        if let signImg = dict.object(forKey: "signatureImage") as? String {
            self.signatureImage = signImg
        }
        if let initImg = dict.object(forKey: "initialImage") as? String  {
            self.initialImage = initImg
        }
        if let signType = dict.object(forKey: "signatureType") as? String {
            self.signatureType = signType
        }
        if let initType = dict.object(forKey: "initialType") as? String {
            self.initialType = initType
        }
        if let signTxt = dict.object(forKey: "signaturetext") as? String {
            self.signaturetext = signTxt
        }
        if let initTxt = dict.object(forKey: "initialtext") as? String {
            self.initialtext = initTxt
        }
        if let editProfFont = dict.object(forKey: "editProfilesignFont") as? String {
            self.editProfilesignFont = editProfFont
        }
        if let editProfFontSize = dict.object(forKey: "editProfilesignFontsize") as? String {
            self.editProfilesignFontsize = editProfFontSize
        }
        if let editProfFont = dict.object(forKey: "editProfileinitFont") as? String {
            self.editProfileinitFont = editProfFont
        }
        if let editProfFontSize = dict.object(forKey: "editProfileinitFontsize") as? String {
            self.editProfileinitFontsize = editProfFontSize
        }
        if let signPath = dict.object(forKey: "signaturePath") as? NSArray {
            
            self.signaturePath = []
            for path in signPath {
                
                let pathdic = path as! NSDictionary
                let spath = SignaturePath()
                spath.populate(fromDictionary: pathdic)
                self.signaturePath?.append(spath)
            }
        }
        if let signPath = dict.object(forKey: "initialPath") as? NSArray {
            
            self.initialPath = []
            for path in signPath {
                
                let pathdic = path as! NSDictionary
                let spath = SignaturePath()
                spath.populate(fromDictionary: pathdic)
                self.initialPath?.append(spath)
            }
        }
        
        if let signIsolated = dict.object(forKey: "signatureIsolatedPoints") as? NSDictionary {
            
            self.signatureIsolatedPoints = CGPoint(x: signIsolated["x"] as! CGFloat, y: signIsolated["y"] as! CGFloat)
        }
        if let signIsolated = dict.object(forKey: "initialIsolatedPoints") as? NSDictionary {
           
            self.initialIsolatedPoints = CGPoint(x: signIsolated["x"] as! CGFloat, y: signIsolated["y"] as! CGFloat)
        }
        if let penW = dict.object(forKey: "penWidth") as? Int {
            self.penWidth = penW
        }
        if let penClr = dict.object(forKey: "PenColor") as? String {
            self.PenColor = penClr
        }
        if let penClrSlider = dict.object(forKey: "penColorSliderPosition") as? Int{
            self.penColorSliderPosition = penClrSlider
        }
        if let signW = dict.object(forKey: "signatureWidth") as? Int {
            self.signatureWidth = signW
        }
        if let signHgt = dict.object(forKey: "signatureHeight") as? Int {
            self.signatureHeight = signHgt
        }
        if let initW = dict.object(forKey: "initialWidth") as? Int {
            self.initialWidth = initW
        }
        if let initHgt = dict.object(forKey: "initialHeight") as? Int {
            self.initialHeight = initHgt
        }
        
    }
}
